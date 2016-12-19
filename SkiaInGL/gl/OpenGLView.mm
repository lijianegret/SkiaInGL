//
//  OpenGLView.m
//  SkiaInGL
//
//  Created by egret0 on 12/7/16.
//  Copyright © 2016 egret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLView.h"
#include "General.h"
#include <SkCGUtils.h>
#include <SkPath.h>
#include <SkGraphics.h>

#include "SkiaModuleConstants.h"
#include "SkiaModuleCanvas.h"

typedef struct {
    float Position[3];
    float Color[4];
    float UV[2];
} Vertex;

const Vertex Vertices[] = {
    {{1, -1, 0}, {0.5f, 0, 0, 0.5f}, {1, 1}},
    {{1, 1, 0}, {0.5f, 0, 0, 0.5f}, {1, 0}},
    {{-1, 1, 0}, {0, 0.5f, 0, 0.5f}, {0, 0}},
    {{-1, -1, 0}, {0, 0.5f, 0, 0.5f}, {0, 1}}
};

const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0
};

const GLfloat projection[] = {
    2.000000, 0.000000, 0.000000, 0.000000,
    0.000000, 1.126761, 0.000000, 0.000000,
    0.000000, 0.000000, -2.333333, -1.000000,
    0.000000, 0.000000, -13.333333, 0.000000
};

const GLfloat modelView[] = {
    1.000000, 0.000000, 0.000000, 0.000000,
    0.000000, 1.000000, 0.000000, 0.000000,
    0.000000, 0.000000, 1.000000, 0.000000,
    0.000000, -2.000000, -5.000000, 1.000000
};

GLfloat modelView2[] = {
    1.000000, 0.000000, 0.000000, 0.000000,
    0.000000, 1.000000, 0.000000, 0.000000,
    0.000000, 0.000000, 1.000000, 0.000000,
    0.000000, 2.000000, -5.000000, 1.000000
};

@implementation OpenGLView

+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

- (void) setupLayer
{
//    _eaglLayer = (CAEAGLLayer *)self.layer;
//    _eaglLayer.opaque = YES;
    _eaglLayer = [CAEAGLLayer layer];
    _eaglLayer.bounds = self.bounds;
    _eaglLayer.anchorPoint = CGPointMake(0, 0);
    _eaglLayer.opaque = YES;
    [self.layer addSublayer:_eaglLayer];
}

- (void) setupContext
{
    _context = General::getInstance()->_context;
}

- (void) setupDepthBuffer
{
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
}

- (void) setupRenderBuffer
{
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void) setupFrameBuffer
{
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER,
                              _colorRenderBuffer);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

- (GLuint) compileShader:(NSString*)shaderName withType:(GLenum)shaderType
{
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString)
    {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char* shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE)
    {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
}

- (void) compileShaders
{
    GLuint vertexShader = [self compileShader:@"SimpleVertex"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment"
                                       withType:GL_FRAGMENT_SHADER];
    
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE)
    {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    glUseProgram(programHandle);
    
    _positionSlot = glGetAttribLocation(programHandle, "a_position");
    _colorSlot = glGetAttribLocation(programHandle, "a_color");
    _uvSlot = glGetAttribLocation(programHandle, "a_uv");
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    glEnableVertexAttribArray(_uvSlot);
    
    _projectionUniform = glGetUniformLocation(programHandle, "u_projection");
    _modelViewUniform = glGetUniformLocation(programHandle, "u_modelView");
    _textureUniform = glGetUniformLocation(programHandle, "u_samplerTexture");
}

- (void) setupVBOs
{
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}

- (void) loadTexture
{
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_SRC_COLOR);
    
    glGenTextures(1, &_texture);
    
    glBindTexture(GL_TEXTURE_2D, _texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    NSData* texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage* image = [[UIImage alloc] initWithData:texData];
    
    GLuint width = CGImageGetWidth(image.CGImage);
    GLuint height = CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void* imageData = malloc(height * width * 4);
    
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, 4 * width,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    CGContextTranslateCTM(context, 0, height - height);
    CGContextDrawImage(context, CGRectMake( 0, 0, width, height ), image.CGImage);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA,
                 GL_UNSIGNED_BYTE, imageData);
    
    CGContextRelease(context);
    
    free(imageData);
}

- (void) render:(CADisplayLink *)displayLink
{
    //skia
    _skiaManager->createCanvas(0, 0, 32, 32);
    _skiaManager->drawRect(5, 5, 10, 10);
    GLuint temp = _skiaManager->getCanvasRenderTexture();
    
//    _skiaModule = SkiaModule::getInstance();
//    
//    _skiaModule->createCanvas(_width, _height);
//    
//    _skiaModule->setColor(Skia_ColorRED);
//    _skiaModule->setAntiAlias(true);
//    _skiaModule->setTextSize(80);
//    _skiaModule->clear(0x00000000);
//    _skiaModule->drawText("ABC", 3, 50, 50);
//    
//    _skiaModule->setColor(Skia_ColorBLUE);
//    _skiaModule->drawRect(50, 50, 100, 100);
//    _skiaModule->drawCircle(100, 200, 50);
//    _skiaModule->drawEllipse(50, 250, 150, 100);
//    _skiaModule->drawArc(200, 100, 50, 0, 200, false);
//    
//    _skiaModule->setColor(Skia_ColorGREEN);
//    _skiaModule->save();
//    _skiaModule->translate(200, 200);
//    const float scale = 256.0f;
//    const float R = 0.45f * scale;
//    const float TAU = 6.2831853f;
//    _skiaModule->beginPath();
//    _skiaModule->pathMoveTo(R, 0.0f);
//    for (int i = 1; i < 7; ++i)
//    {
//        SkScalar theta = 3 * i * TAU / 7;
//        _skiaModule->pathLineTo(R * cos(theta), R * sin(theta));
//    }
//    _skiaModule->endPath();
//    _skiaModule->restore();
//    
//    _skiaModule->getCanvasRenderTexture(_texture1);
    
    
    // gl
    glClearColor(0.5, 0.5, 1.0, 1.0);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    glUniformMatrix4fv(_projectionUniform, 1, 0, projection);
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), (GLvoid*)(sizeof(float) * 3));
    glVertexAttribPointer(_uvSlot, 2, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), (GLvoid*)(sizeof(float) * 7));
    
    glBindTexture(GL_TEXTURE_2D, _texture);
//    _skiaModule->getCanvasRenderTexture();
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),
                   GL_UNSIGNED_BYTE, 0);
    
    float offsetX = displayLink.duration / 10;
    modelView2[12] += offsetX;
    if (modelView2[12] > 3.0)
    {
        modelView2[12] = -3.0;
    }
    
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView2);
    _skiaManager->bindTexture(temp);
//    glBindTexture(GL_TEXTURE_2D, _skiaManager->getCanvasRenderTexture());
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),
                   GL_UNSIGNED_BYTE, 0);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    glDisable(GL_DEPTH_TEST);
    
//    _skiaModule->update();
    _skiaManager->update();
}

- (void) setupSkiaLayer
{
//    _skiaModule = SkiaModule::getInstance();
//    _skiaModule->createCanvas(_width, _height);
    _skiaManager = new egret::SkiaManager();
    
//    glGenTextures(1, &_texture1);
    
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _width = 512;
        _height = 512;
        
        [self setupLayer];
        [self setupContext];
        [self setupSkiaLayer];
        
        [self setupDepthBuffer];
        
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        
        [self compileShaders];
        [self setupVBOs];
        [self loadTexture];
    }
    return self;
}

@end
