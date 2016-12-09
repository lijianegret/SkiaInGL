//
//  SkiaView.m
//  SkiaInGL
//
//  Created by egret0 on 12/9/16.
//  Copyright © 2016 egret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkiaView.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@implementation SkiaView

- (void) initWithDefaults
{
//    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    
//    if (!_context || ![EAGLContext setCurrentContext:_context])
//    {
//        return;
//    }
    
//    glGenFramebuffers(1, &_frameBuffer);
//    glBindBuffer(GL_FRAMEBUFFER, _frameBuffer);
//    
//    glGenRenderbuffers(1, &_renderBuffer);
//    glGenRenderbuffers(1, &_stencailBuffer);
//    
//    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
//    
//    glBindRenderbuffer(GL_RENDERBUFFER, _stencailBuffer);
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, _stencailBuffer);
    
//    _glLayer = [CAEAGLLayer layer];
//    _glLayer.bounds = self.bounds;
//    _glLayer.anchorPoint = CGPointMake(0, 0);
//    _glLayer.opaque = TRUE;
//    [self.layer addSublayer:_glLayer];
//    _glLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
//                                   kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
//                                   nil];
    
//    _rasterLayer = [CALayer layer];
//    _rasterLayer.anchorPoint = CGPointMake(0, 0);
//    _rasterLayer.opaque = TRUE;
//    [self.layer addSublayer:_rasterLayer];
    
    
}

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initWithDefaults];
    }
    return self;
}

@end


































