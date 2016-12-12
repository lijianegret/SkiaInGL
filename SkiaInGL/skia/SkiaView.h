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
#include <SkSurface.h>
#include <SkCanvas.h>

@interface SkiaView : UIView
{
    EAGLContext* _context;
    
    CALayer* _rasterLayer;
    
    SkBitmap _bitmap;
    sk_sp<SkSurface> _surface;
    SkCanvas* _canvas;
    int _width;
    int _height;
}

- (void) render:(CADisplayLink *)displayLink;

@end

#endif /* SkiaView_h */
