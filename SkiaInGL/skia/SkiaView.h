//
//  SkiaView.h
//  SkiaInGL
//
//  Created by egret0 on 12/9/16.
//  Copyright © 2016 egret. All rights reserved.
//

#ifndef SkiaView_h
#define SkiaView_h

#import <UIKit/UIKit.h>
#include <SkBitmap.h>

@interface SkiaView : UIView
{
    EAGLContext* _context;
    GLuint _renderBuffer;
    GLuint _stencailBuffer;
    GLuint _frameBuffer;
    GLuint _width;
    GLuint _height;
    
    CALayer* _rasterLayer;
    CAEAGLLayer* _glLayer;
    
    
}

@end

#endif /* SkiaView_h */
