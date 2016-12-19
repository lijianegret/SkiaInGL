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
    
    void setPaintStyle(int style);
    void beginPath();
    void endPath();
    void pathMoveTo(float x, float y);
    void pathLineTo(float x, float y);
    void pathCurveTo(float controlX, float controlY, float anchorX, float anchorY);
    void pathCubeCurveTo(float controlX1, float controlY1, float controlX2, float controlY2,
                         float anchorX, float anchorY);
    
    void drawRect(float x, float y, float width, float height);
    void drawRoundRect(float x, float y, float width, float height, float ellipseWidth, float ellipseHeight);
    void drawArc(float x, float y, float radius, float startAngle, float endAngle, bool antiClockWise);
    void drawCircle(float x, float y, float radius);
    void drawEllipse(float x, float y, float width, float height);
    
    void drawText(const char* text, size_t byteLength, float x, float y);
    
private:
    SkiaModule();
    
private:
    static SkiaModule* _skiaModule;
    SkiaModuleCanvas* _currentCanvas;
    SkiaModuleCanvasStore* _canvasStore;
};
