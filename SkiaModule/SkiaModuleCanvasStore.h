//
//  SkiaModuleCanvasStore.h
//  SkiaInGL
//
//  Created by egret0 on 12/15/16.
//  Copyright © 2016 egret. All rights reserved.
//

#ifndef SkiaModuleCanvasStore_h
#define SkiaModuleCanvasStore_h

#define LIST_LENGTH 50

class SkiaModuleCanvas;

class CanvasList
{
public:
    CanvasList();
    ~CanvasList();
    SkiaModuleCanvas* getNewCanvas();
    
public:
    SkiaModuleCanvas* canvasList[LIST_LENGTH];
    CanvasList* next;
    int size;
    int index;
};

class SkiaModuleCanvasStore
{
public:
    SkiaModuleCanvasStore();
    ~SkiaModuleCanvasStore();
    
    SkiaModuleCanvas* getNewCanvas();
    SkiaModuleCanvas* getCurrCanvas();
    
    void update();
    
private:
    CanvasList* _firstList;
    CanvasList* _currList;
    SkiaModuleCanvas* _currCanvas;
};

#endif /* SkiaModuleCanvasStore_h */
