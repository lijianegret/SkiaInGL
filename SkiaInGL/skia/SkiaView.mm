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
#include "General.h"
#include <SkCGUtils.h>
#include <SkPath.h>

@implementation SkiaView

- (void) initCanvasWithWidth:(int)width Height:(int)height
{    
    _bitmap.allocN32Pixels(0, 0);
    SkImageInfo info = _bitmap.info().makeWH(width, height);
    _bitmap.allocPixels(info);
    
    _surface = SkSurface::MakeRasterDirect(_bitmap.info(), _bitmap.getPixels(), _bitmap.rowBytes());
    
    _canvas = _surface->getCanvas();
    
    _width = width;
    _height = height;
}

- (void) initWithDefaults
{
    _context = General::getInstance()->_context;
    
    _rasterLayer = [CALayer layer];
    _rasterLayer.bounds = self.bounds;
    _rasterLayer.anchorPoint = CGPointMake(0, 0);
    [self.layer addSublayer:_rasterLayer];
}

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initWithDefaults];
        [self initCanvasWithWidth:frame.size.width Height:frame.size.height];
    }
    return self;
}

- (void) render:(CADisplayLink *)displayLink
{
    SkPaint paint;
    paint.setColor(SK_ColorBLUE);
    paint.setAntiAlias(true);
    
    _canvas->clear(0xFFFFFF00);
    
    _canvas->drawText("AAA", 3, 10, 10, paint);
    
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
    _canvas->translate(0.5f * scale, 0.5f * scale);
    _canvas->drawPath(path, paint);
    
    _canvas->restore();
    
    CGImageRef cgImage = SkCreateCGImageRef(_bitmap);
    _rasterLayer.contents = (__bridge id)cgImage;
    CGImageRelease(cgImage);
}

@end


































