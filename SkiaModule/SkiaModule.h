//
//  SkiaModule.h
//  SkiaModule
//
//  Created by lijian on 12/14/16.
//  Copyright © 2016 egret. All rights reserved.
//

#include <OpenGLES/ES2/gl.h>
#include <stdlib.h>

class SkiaModuleCanvas;
class SkiaModuleCanvasStore;
class SkiaModule
{
public:
    static SkiaModule* getInstance();
    ~SkiaModule();
    void update();
    
    void createCanvas(int width, int height);
    void getCanvasRenderTexture(GLuint textureId);
    
    void setColor(uint32_t color);
    void setAntiAlias(bool antiAlias);
    void setTextSize(float textSize);
    
    void clear(uint32_t clearColor);
    
    void save();
    void restore();
    void translate(float dx, float dy);
    
    void beginPath();
    void endPath();
    void pathMoveTo(float x, float y);
    void pathLineTo(float x, float y);
    
    void drawText(const char* text, size_t byteLength, float x, float y);
    
private:
    SkiaModule();
    
private:
    static SkiaModule* _skiaModule;
    SkiaModuleCanvas* _currentCanvas;
    SkiaModuleCanvasStore* _canvasStore;
};
