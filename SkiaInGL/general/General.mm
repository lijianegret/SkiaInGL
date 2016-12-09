//
//  General.m
//  SkiaInGL
//
//  Created by egret0 on 12/9/16.
//  Copyright © 2016 egret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "General.h"

General* General::_instance = nullptr;

General* General::getInstance()
{
    if (!_instance)
    {
        _instance = new General();
    }
    return _instance;
}

General::General()
{
    initEAGLContext();
}

General::~General()
{
    
}

void General::initEAGLContext()
{
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context)
    {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context])
    {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}
