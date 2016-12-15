//
//  SkiaModuleCanvasStore.cpp
//  SkiaInGL
//
//  Created by egret0 on 12/15/16.
//  Copyright © 2016 egret. All rights reserved.
//

#include "SkiaModuleCanvasStore.h"
#include "SkiaModuleCanvas.h"

CanvasList::CanvasList()
: next(nullptr)
, size(0)
, index(0)
{
    
}

CanvasList::~CanvasList()
{
    next = nullptr;
    for (int i = 0; i < size; i++)
    {
        delete canvasList[i];
    }
}

SkiaModuleCanvas* CanvasList::getNewCanvas()
{
    if (index < size)
    {
        index ++;
        return canvasList[index - 1];
    }
    else if (size < LIST_LENGTH)
    {
        canvasList[size] = new SkiaModuleCanvas();
        size ++;
        index = size;
        return canvasList[index - 1];
    }
    return nullptr;
}

SkiaModuleCanvasStore::SkiaModuleCanvasStore()
: _currCanvas(nullptr)
{
    _firstList = new CanvasList();
    _currList = _firstList;
}

SkiaModuleCanvasStore::~SkiaModuleCanvasStore()
{
    _currCanvas = nullptr;
    CanvasList* temp = _firstList;
    while (temp != nullptr)
    {
        temp = _firstList->next;
        delete _firstList;
        _firstList = temp;
    }
}

SkiaModuleCanvas* SkiaModuleCanvasStore::getNewCanvas()
{
    _currCanvas = _currList->getNewCanvas();
    if (_currCanvas != nullptr)
    {
        return _currCanvas;
    }
    if (_currList->next != nullptr)
    {
        _currList = _currList->next;
    }
    _currCanvas = _currList->getNewCanvas();
    return _currCanvas;
}

SkiaModuleCanvas* SkiaModuleCanvasStore::getCurrCanvas()
{
    return _currCanvas;
}

void SkiaModuleCanvasStore::update()
{
    CanvasList* temp = _firstList;
    while (temp != nullptr)
    {
        temp->index = 0;
        temp = temp->next;
    }
}
