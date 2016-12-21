//
//  SkiaImage.hpp
//  SkiaInGL
//
//  Created by lijian on 12/21/16.
//  Copyright © 2016 egret. All rights reserved.
//

#ifndef SkiaImage_hpp
#define SkiaImage_hpp

#include <stdlib.h>

class SkBitmap;
class SkiaImage
{
public:
    SkiaImage();
    ~SkiaImage();
    
    bool initWithImageData(const unsigned char* data, int dataLen);
    bool isCompressed();
    bool hasPremultipliedAlpha();
    int getRenderFormat();
    bool premultipliedAlpha();
    
    int getWidth();
    int getHeight();
    int getPixelFormat();
    int getPixelInternalFormat();
    int getDataLen();
    uint8_t* getData();
    
private:
    SkBitmap* _bitmap;
    int _width;
    int _height;
    int _pixelFormat;
    int _dataLen;
    uint8_t* _data;
};

#endif /* SkiaImage_hpp */
