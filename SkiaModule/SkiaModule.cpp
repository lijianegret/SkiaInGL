//
//  SkiaModule.m
//  SkiaModule
//
//  Created by lijian on 12/14/16.
//  Copyright © 2016 egret. All rights reserved.
//

#include "SkiaModule.h"
#include "SkiaModuleCanvas.h"
#include "SkiaModuleCanvasStore.h"

SkiaModule* SkiaModule::_skiaModule = nullptr;

SkiaModule* SkiaModule::getInstance()
{
    if (_skiaModule == nullptr)
    {
        _skiaModule = new SkiaModule();
    }
    return _skiaModule;
}

SkiaModule::SkiaModule()
: _currentCanvas(nullptr)
{
    _canvasStore = new SkiaModuleCanvasStore();
}

SkiaModule::~SkiaModule()
{
    
}

void SkiaModule::update()
{
    _canvasStore->update();
}

void SkiaModule::createCanvas(int width, int height)
{
    _currentCanvas = _canvasStore->getNewCanvas();
    _currentCanvas->resize(width, height);
}

void SkiaModule::getCanvasRenderTexture(GLuint textureId)
{
    _currentCanvas->getCanvasRenderTexture(textureId);
}

void SkiaModule::setColor(uint32_t color)
{
    _currentCanvas->setColor(color);
}

void SkiaModule::setAlpha(float alpha)
{
    uint32_t alpha_int = (uint32_t)alpha * 255;
    _currentCanvas->setAlpha(alpha_int);
}

void SkiaModule::setStrokeWidth(int width)
{
    _currentCanvas->setStrokeWidth(width);
}

void SkiaModule::setAntiAlias(bool antiAlias)
{
    _currentCanvas->setAntiAlias(antiAlias);
}

int SkiaModule::getTextSize(const char* text, int length)
{
    return _currentCanvas->getTextSize(text, length);
}

void SkiaModule::setTextSize(float textSize)
{
    _currentCanvas->setTextSize(textSize);
}

void SkiaModule::clear(uint32_t clearColor)
{
    _currentCanvas->clear(clearColor);
}

void SkiaModule::save()
{
    _currentCanvas->save();
}

void SkiaModule::restore()
{
    _currentCanvas->restore();
}

void SkiaModule::translate(float dx, float dy)
{
    _currentCanvas->translate(dx, dy);
}

void SkiaModule::setPaintStyle(int style)
{
    _currentCanvas->setPaintStyle(style);
}

void SkiaModule::beginPath()
{
    _currentCanvas->beginPath();
}

void SkiaModule::endPath()
{
    _currentCanvas->endPath();
}

void SkiaModule::pathMoveTo(float x, float y)
{
    _currentCanvas->pathMoveTo(x, y);
}

void SkiaModule::pathLineTo(float x, float y)
{
    _currentCanvas->pathLineTo(x, y);
}

void SkiaModule::pathCurveTo(float controlX, float controlY, float anchorX, float anchorY)
{
    _currentCanvas->pathCurveTo(controlX, controlY, anchorX, anchorY);
}

void SkiaModule::pathCubeCurveTo(float controlX1, float controlY1, float controlX2, float controlY2,
                                 float anchorX, float anchorY)
{
    _currentCanvas->pathCubeCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
}

void SkiaModule::drawRect(float x, float y, float width, float height)
{
    _currentCanvas->drawRect(x, y, width, height);
}

void SkiaModule::drawRoundRect(float x, float y, float width, float height, float ellipseWidth,
                               float ellipseHeight)
{
    _currentCanvas->drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);
}

void SkiaModule::drawArc(float x, float y, float radius, float startAngle, float endAngle, bool antiClockWise)
{
    _currentCanvas->drawArc(x, y, radius, startAngle, endAngle, antiClockWise);
}

void SkiaModule::drawCircle(float x, float y, float radius)
{
    _currentCanvas->drawCircle(x, y, radius);
}

void SkiaModule::drawEllipse(float x, float y, float width, float height)
{
    _currentCanvas->drawEllipse(x, y, width, height);
}

void SkiaModule::drawText(const char* text, size_t byteLength, float x, float y)
{
    _currentCanvas->drawText(text, byteLength, x, y);
}

void SkiaModule::drawText(const char* text, size_t byteLength, float x, float y, float width, float height)
{
    _currentCanvas->drawText(text, byteLength, x, y, width, height);
}






















