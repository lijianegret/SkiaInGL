//
//  SkiaModuleCanvas.cpp
//  SkiaInGL
//
//  Created by egret0 on 12/15/16.
//  Copyright © 2016 egret. All rights reserved.
//

#include "SkiaModuleCanvas.h"
#include "SkiaModuleCanvasStore.h"

SkiaModuleCanvas::SkiaModuleCanvas()
{
    _bitmap.allocN32Pixels(0, 0);
}

void SkiaModuleCanvas::resize(int width, int height)
{
    if (_width == width && _height == height)
    {
        return;
    }
    
    SkImageInfo info = _bitmap.info().makeWH(width, height);
    info.makeColorType(SkColorType::kBGRA_8888_SkColorType);
    _bitmap.allocPixels(info);
    
    _surface = SkSurface::MakeRasterDirect(_bitmap.info(), _bitmap.getPixels(), _bitmap.rowBytes());
    _canvas = _surface->getCanvas();
    
    _width = width;
    _height = height;
}

SkiaModuleCanvas::~SkiaModuleCanvas()
{
    delete _canvas;
}

void SkiaModuleCanvas::getCanvasRenderTexture(GLuint textureId)
{
    glBindTexture(GL_TEXTURE_2D, textureId);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _width, _height, 0, GL_RGBA,
                 GL_UNSIGNED_BYTE, _bitmap.getPixels());
}

void SkiaModuleCanvas::setColor(uint32_t color)
{
    _paint.setColor(color);
}

void SkiaModuleCanvas::setAntiAlias(bool antiAlias)
{
    _paint.setAntiAlias(antiAlias);
}

void SkiaModuleCanvas::setTextSize(float textSize)
{
    _paint.setTextSize(textSize);
}

void SkiaModuleCanvas::clear(uint32_t clearColor)
{
    _canvas->clear(clearColor);
}

void SkiaModuleCanvas::save()
{
    _canvas->save();
}

void SkiaModuleCanvas::restore()
{
    _canvas->restore();
}

void SkiaModuleCanvas::translate(float dx, float dy)
{
    _canvas->translate(dx, dy);
}

void SkiaModuleCanvas::setPaintStyle(int style)
{
    if (style == 1)
    {
        _paint.setStyle(SkPaint::kFill_Style);
    }
    else if (style == 3)
    {
        _paint.setStyle(SkPaint::kStroke_Style);
    }
    else {
        _paint.setStyle(SkPaint::kFill_Style);
    }
}

void SkiaModuleCanvas::beginPath()
{
    _path.reset();
}

void SkiaModuleCanvas::endPath()
{
    _path.close();
    _canvas->drawPath(_path, _paint);
}

void SkiaModuleCanvas::pathMoveTo(float x, float y)
{
    _path.moveTo(x, y);
}

void SkiaModuleCanvas::pathLineTo(float x, float y)
{
    _path.lineTo(x, y);
}

void SkiaModuleCanvas::pathCurveTo(float controlX, float controlY, float anchorX, float anchorY)
{
    _path.cubicTo(controlX, controlY, controlX, controlY, anchorX, anchorY);
}

void SkiaModuleCanvas::pathCubeCurveTo(float controlX1, float controlY1, float controlX2, float controlY2,
                                       float anchorX, float anchorY)
{
    _path.cubicTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
}

void SkiaModuleCanvas::drawRect(float x, float y, float width, float height)
{
    SkRect rect;
    rect.setXYWH(x, y, width, height);
    _canvas->drawRect(rect, _paint);
}

void SkiaModuleCanvas::drawRoundRect(float x, float y, float width, float height,
                                     float ellipseWidth, float ellipseHeight)
{
    SkRect rect;
    rect.setXYWH(x, y, width, height);
    _canvas->drawRoundRect(rect, ellipseWidth, ellipseHeight, _paint);
}

void SkiaModuleCanvas::drawArc(float x, float y, float radius, float startAngle, float endAngle, bool antiClockWise)
{
    SkRect rect;
    rect.setXYWH(x - radius, y - radius, radius * 2, radius * 2);
    _canvas->drawArc(rect, startAngle, endAngle - startAngle, false, _paint);
}

void SkiaModuleCanvas::drawCircle(float x, float y, float radius)
{
    _canvas->drawCircle(x, y, radius, _paint);
}

void SkiaModuleCanvas::drawEllipse(float x, float y, float width, float height)
{
    SkRect rect;
    rect.setXYWH(x, y, width, height);
    _canvas->drawOval(rect, _paint);
}

void SkiaModuleCanvas::drawText(const char* text, size_t byteLength, float x, float y)
{
    _canvas->drawText(text, byteLength, x, y, _paint);
}




























