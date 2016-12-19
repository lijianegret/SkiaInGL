//
//  SkiaManager.m
//  EgretWebGLFramework
//
//  Created by lijian on 12/15/16.
//  Copyright © 2016 Egret. All rights reserved.
//

#include "SkiaManager.h"
#include <SkiaModule/SkiaModule.h>
#include <SkiaModule/SkiaModuleConstants.h>

using namespace egret;

SkiaManager::SkiaManager()
: _texListIndex(0)
, _texListSize(0)
{
    _skiaModule = SkiaModule::getInstance();
}

SkiaManager::~SkiaManager()
{
    dispose();
}

void SkiaManager::dispose()
{
    if (_textureList.empty())
    {
        return;
    }
    
    for (int i = 0; i < _textureList.size(); i++)
    {
        GLuint tex = _textureList[i];
        glDeleteTextures(1, &tex);
    }
    delete _skiaModule;
}

void SkiaManager::update()
{
    _skiaModule->update();
    _texListIndex = 0;
}

void SkiaManager::createCanvas(float x, float y, float width, float height)
{
    _skiaModule->createCanvas(width, height);
    _skiaModule->clear(0x00000000);
    _skiaModule->translate(-x, -y);
}

void SkiaManager::drawRect(float x, float y, float width, float height)
{
    _skiaModule->setColor(Skia_ColorRED);
    _skiaModule->drawRect(x, y, width, height);
}

GLuint SkiaManager::getCanvasRenderTexture()
{
    if (_texListIndex < _texListSize)
    {
        _skiaModule->getCanvasRenderTexture(_textureList[_texListIndex]);
        return _textureList[_texListIndex++];
    }
    GLuint texture;
    _texListSize++;
    _textureList.push_back(texture);
    glGenTextures(1, &(_textureList[_texListIndex]));
    glBindTexture(GL_TEXTURE_2D, _textureList[_texListIndex]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    _skiaModule->getCanvasRenderTexture(_textureList[_texListIndex]);
    
    return _textureList[_texListIndex++];;
}

void SkiaManager::bindTexture(GLuint textureId)
{
    glBindTexture(GL_TEXTURE_2D, textureId);
    bool temp = glIsTexture(textureId);
    temp = true;
}
