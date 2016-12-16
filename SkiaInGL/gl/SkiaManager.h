//
//  SkiaManager.h
//  EgretWebGLFramework
//
//  Created by lijian on 12/15/16.
//  Copyright © 2016 Egret. All rights reserved.
//

#ifndef SkiaManager_h
#define SkiaManager_h

#include <vector>
#include <OpenGLES/ES2/glext.h>

class SkiaModule;

namespace egret
{
    class SkiaManager
    {
    public:
        SkiaManager();
        ~SkiaManager();
        
        void dispose();
        void update();
        
        void createCanvas(float x, float y, float width, float height);
        
        void drawRect(float x, float y, float width, float height);
        
        GLuint getCanvasRenderTexture();
        
    private:
        SkiaModule* _skiaModule;
        std::vector<GLuint> _textureList;
        int _texListIndex;
        int _texListSize;
    };
}

#endif /* SkiaManager_h */
