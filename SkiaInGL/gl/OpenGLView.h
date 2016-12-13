//
//  OpenGLView.h
//  SkiaInGL
//
//  Created by egret0 on 12/7/16.
//  Copyright © 2016 egret. All rights reserved.
//

#ifndef OpenGLView_h
#define OpenGLView_h

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <SkBitmap.h>
#include <SkSurface.h>
#include <SkCanvas.h>

@interface OpenGLView : UIView
{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _uvSlot;
    
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    GLuint _textureUniform;
    GLuint _depthRenderBuffer;
    
    GLuint _texture[2];
    
    
    CALayer* _rasterLayer;
    SkBitmap _bitmap;
    sk_sp<SkSurface> _surface;
    SkCanvas* _canvas;
    GrContext* _grContext;
    float _rot;
    GLuint _textureId;
    
    
    int _width;
    int _height;
}

- (void) render:(CADisplayLink *)displayLink;

@end

#endif /* OpenGLView_h */
