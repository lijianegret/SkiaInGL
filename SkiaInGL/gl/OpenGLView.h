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
#include "SkiaModule.h"
#include "SkiaManager.h"

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
    
    GLuint _texture;
    GLuint _texture1;
    
    
//    SkiaModule* _skiaModule;
    egret::SkiaManager* _skiaManager;
    
    
    int _width;
    int _height;
}

- (void) render:(CADisplayLink *)displayLink;

@end

#endif /* OpenGLView_h */
