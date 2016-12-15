//
//  SkiaModule.m
//  SkiaModule
//
//  Created by lijian on 12/14/16.
//  Copyright © 2016 egret. All rights reserved.
//

#include "SkiaModule.h"
#include "SkiaModuleCanvas.h"

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
    
}

SkiaModule::~SkiaModule()
{
    
}

void SkiaModule::createCanvas(int width, int height)
{
    _currentCanvas = new SkiaModuleCanvas(width, height);
}

void SkiaModule::getCanvasRenderTexture(GLuint textureId)
{
    _currentCanvas->getCanvasRenderTexture(textureId);
}

void SkiaModule::setColor(uint32_t color)
{
    _currentCanvas->setColor(color);
}

void SkiaModule::setAntiAlias(bool antiAlias)
{
    _currentCanvas->setAntiAlias(antiAlias);
}

void SkiaModule::setTextSize(float textSize)
{
    _currentCanvas->setTextSize(textSize);
}

void SkiaModule::clear(uint32_t clearColor)
{
    _currentCanvas->clear(clearColor);
}

void SkiaModule::drawText(const char* text, size_t byteLength, float x, float y)
{
    _currentCanvas->drawText(text, byteLength, x, y);
}






















