//
//  SkiaModuleCanvas.cpp
//  SkiaInGL
//
//  Created by egret0 on 12/15/16.
//  Copyright © 2016 egret. All rights reserved.
//

#include "SkiaModuleCanvas.h"

SkiaModuleCanvas::SkiaModuleCanvas()
{
    
}

SkiaModuleCanvas::SkiaModuleCanvas(int width, int height)
{
    _bitmap.allocN32Pixels(0, 0);
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
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
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

void SkiaModuleCanvas::drawText(const char* text, size_t byteLength, float x, float y)
{
    _canvas->drawText(text, byteLength, x, y, _paint);
    _paint.setStrokeWidth(10);
    _canvas->drawLine(0, 0, _width, _height, _paint);
}




























