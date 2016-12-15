//
//  SkiaModuleCanvas.h
//  SkiaInGL
//
//  Created by egret0 on 12/15/16.
//  Copyright © 2016 egret. All rights reserved.
//

#ifndef SkiaModuleCanvas_h
#define SkiaModuleCanvas_h

#include <OpenGLES/ES2/gl.h>
#include <SkBitmap.h>
#include <SkSurface.h>
#include <SkCanvas.h>
#include <SkPath.h>
#include <SkGraphics.h>

class SkiaModuleCanvas
{
public:
    SkiaModuleCanvas();
    ~SkiaModuleCanvas();
    void resize(int width, int height);
    
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
    SkBitmap _bitmap;
    sk_sp<SkSurface> _surface;
    SkCanvas* _canvas;
    SkPaint _paint;
    SkPath _path;
    
    int _width;
    int _height;
};

#endif /* SkiaModuleCanvas_h */
