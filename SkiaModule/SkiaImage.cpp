//
//  SkiaImage.cpp
//  SkiaInGL
//
//  Created by lijian on 12/21/16.
//  Copyright © 2016 egret. All rights reserved.
//

#include "SkiaImage.h"
#include <SkBitmap.h>
#include <SkCanvas.h>
#include <SkData.h>
#include <SkImageGenerator.h>

#include <SkCodec.h>

SkiaImage::SkiaImage()
: _bitmap(new SkBitmap)
, _width(0)
, _height(0)
, _pixelFormat(-1)
, _dataLen(0)
, _data(nullptr)
{
    
}

SkiaImage::~SkiaImage()
{
    
}

bool SkiaImage::initWithImageData(const unsigned char* data, int dataLen)
{
    if (!dataLen)
    {
        return false;
    }
    sk_sp<SkData> skData = SkData::MakeWithoutCopy(data, dataLen);
    std::unique_ptr<SkImageGenerator> gen(SkImageGenerator::NewFromEncoded(skData.get()));
    if (!gen)
    {
        return false;
    }
    
    SkPMColor ctStorage[256];
    sk_sp<SkColorTable> ctable(new SkColorTable(ctStorage, 256));
    int count = ctable->count();
    
    if (!_bitmap->tryAllocPixels(gen->getInfo(), nullptr, ctable.get()))
    {
        return false;
    }
    if (!gen->getPixels(gen->getInfo().makeColorSpace(nullptr), _bitmap->getPixels(),
                        _bitmap->rowBytes(), const_cast<SkPMColor*>(ctable->readColors()),
                        &count))
    {
        return false;
    }
    
    SkImageInfo info = _bitmap->info();
    printf("%d", info.colorType());
    _width = _bitmap->width();
    _height = _bitmap->height();
    _data = (uint8_t *)_bitmap->getPixels();
    
    return true;
}

bool SkiaImage::isCompressed()
{
    return false;
}

bool SkiaImage::hasPremultipliedAlpha()
{
    return true;
}

int SkiaImage::getRenderFormat()
{
    return _pixelFormat;
}

bool SkiaImage::premultipliedAlpha()
{
    return false;
}

int SkiaImage::getWidth()
{
    return _width;
}

int SkiaImage::getHeight()
{
    return _height;
}

int SkiaImage::getPixelFormat()
{
    return _pixelFormat;
}

int SkiaImage::getPixelInternalFormat()
{
    return _pixelFormat;
}

int SkiaImage::getDataLen()
{
    return _dataLen;
}

uint8_t* SkiaImage::getData()
{
    return _data;
}
