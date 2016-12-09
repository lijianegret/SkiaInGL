//
//  General.h
//  SkiaInGL
//
//  Created by egret0 on 12/9/16.
//  Copyright © 2016 egret. All rights reserved.
//

#ifndef General_h
#define General_h

#include <OpenGLES/EAGL.h>
#include <OpenGLES/ES2/gl.h>

class General
{
public:
    static General* getInstance();
    
private:
    General();
    ~General();
    void initEAGLContext();
    
public:
    EAGLContext* _context;
    
private:
    static General* _instance;
};

#endif /* General_h */
