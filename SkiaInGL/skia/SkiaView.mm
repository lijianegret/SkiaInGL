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

@implementation SkiaView

- (void) initWithDefaults
{
    _context = General::getInstance()->_context;
    
    _rasterLayer = [CALayer layer];
    _rasterLayer.anchorPoint = CGPointMake(0, 0);
    _rasterLayer.opaque = TRUE;
    [self.layer addSublayer:_rasterLayer];
    
    
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


































