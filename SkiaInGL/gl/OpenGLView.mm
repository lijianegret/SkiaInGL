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
#include <GrGLFunctions.h>
#include <GrGLInterface.h>
#include <SkPath.h>
#include <GrContext.h>
#include <SkGraphics.h>

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
    0.000000, 0.000000, -7.000000, 1.000000
};

GLfloat modelView2[] = {
    1.000000, 0.000000, 0.000000, 0.000000,
    0.000000, 1.000000, 0.000000, 0.000000,
    0.000000, 0.000000, 1.000000, 0.000000,
    0.000000, 1.000000, -7.000000, 1.000000
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
    
    glGenTextures(2, &_texture[0]);
    
    glBindTexture(GL_TEXTURE_2D, _texture[0]);
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
    SkPaint paint;
    paint.setColor(SK_ColorBLUE);
    paint.setAntiAlias(true);
    paint.setTextSize(80);
    
    _canvas->clear(0x00000000);
    
    _canvas->drawText("AAA", 3, 50, 50, paint);
    
    _canvas->save();
    
    const SkScalar scale = 256.0f;
    const SkScalar R = 0.45f * scale;
    const SkScalar TAU = 6.2831853f;
    SkPath path;
    path.moveTo(R, 0.0f);
    for (int i = 1; i < 7; ++i) {
        SkScalar theta = 3 * i * TAU / 7;
        path.lineTo(R * cos(theta), R * sin(theta));
    }
    path.close();
    paint.setColor(SK_ColorRED);
    _canvas->translate(0.5f * scale, 0.5f * scale + modelView2[12] * 10);
    _canvas->drawPath(path, paint);
    
    _canvas->restore();
    
    CGImageRef cgImage = SkCreateCGImageRef(_bitmap);
    _rasterLayer.contents = (__bridge id)cgImage;
    CGImageRelease(cgImage);
    
    glBindTexture(GL_TEXTURE_2D, _texture[1]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _width, _height, 0, GL_RGBA,
                 GL_UNSIGNED_BYTE, _bitmap.getPixels());
    
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
    
    glBindTexture(GL_TEXTURE_2D, _texture[0]);
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),
                   GL_UNSIGNED_BYTE, 0);
    
    float offsetX = displayLink.duration / 10;
    modelView2[12] += offsetX;
    if (modelView2[12] > 3.0)
    {
        modelView2[12] = -3.0;
    }
    
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView2);
    glBindTexture(GL_TEXTURE_2D, _texture[1]);
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),
                   GL_UNSIGNED_BYTE, 0);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    glDisable(GL_DEPTH_TEST);
}

- (void) setupSkiaLayer
{
    _rasterLayer = [CALayer layer];
    _rasterLayer.bounds = self.bounds;
    _rasterLayer.anchorPoint = CGPointMake(0, 0);
    [self.layer addSublayer:_rasterLayer];
//
//    SkGraphics::Init();
//    
    _bitmap.allocN32Pixels(0, 0);
    SkImageInfo info = _bitmap.info().makeWH(_width, _height);
    info.makeColorType(SkColorType::kBGRA_8888_SkColorType);
    _bitmap.allocPixels(info);
    
    _surface = SkSurface::MakeRasterDirect(_bitmap.info(), _bitmap.getPixels(), _bitmap.rowBytes());
    
    _canvas = _surface->getCanvas();
//
//    _rot = 0;
//    
//    SkAutoLockPixels alp(_bitmap);
//    
//    glEnable(GL_TEXTURE_2D);
//    glGenTextures(1, &_textureId);
//    glBindTexture(GL_TEXTURE_2D, _textureId);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
//    
//    NSLog(@" >>>>>>> %d %d", _bitmap.width(), _bitmap.height());
    
//    const GrGLInterface* interface = nullptr;
//    _grContext = GrContext::Create(kOpenGL_GrBackend, (GrBackendContext)interface);
//    SkImageInfo info = SkImageInfo::MakeN32Premul(_width, _height);
//    _surface = SkSurface::MakeRenderTarget(_grContext, SkBudgeted::kYes, info);
//    _canvas = _surface->getCanvas();
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
