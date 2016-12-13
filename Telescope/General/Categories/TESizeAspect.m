//
//  TESizeAspect.c
//  Telescope
//
//  Created by zhangguang on 16/12/13.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#include "TESizeAspect.h"


void resizeFrameSizeInSize(CGFloat * sourceWidth,CGFloat * sourceHeight,CGFloat limitWidth,CGFloat limitHeight)
{
    CGFloat actualRectAspect = *sourceWidth / *sourceHeight;
    CGFloat limitRectAspect = limitWidth / limitHeight;
    
    if (actualRectAspect > limitRectAspect) {
        * sourceWidth = limitWidth;
        * sourceHeight = *sourceWidth / actualRectAspect;
    }else {
        * sourceHeight = limitHeight;
        * sourceWidth = *sourceHeight * actualRectAspect;
    }
}

void aspectSizeInContainer(CGFloat* sourceWidth,CGFloat* sourceHeight,CGSize minSize,CGSize maxSize)
{
    if (*sourceWidth <= maxSize.width && *sourceHeight <= maxSize.height) {
        return;
    }
    else if (*sourceWidth <= maxSize.width && *sourceHeight > maxSize.height)
    {
        //宽度不变
        //高度等于最大高度
        *sourceHeight = maxSize.height;
    }
    else if (*sourceWidth > maxSize.width && *sourceHeight <= maxSize.height)
    {
        //高度不变
        //宽度等于最大宽度
        *sourceWidth = maxSize.width;
    }
    else //*sourceWidth > maxSize.width && *sourceHeight > maxSize.height
    {
        //等比缩放
        resizeFrameSizeInSize(sourceWidth,sourceHeight,maxSize.width,maxSize.height);
        if (*sourceWidth < minSize.width) {
            *sourceWidth = minSize.width;
        }
        
        if (*sourceHeight < minSize.height) {
            *sourceHeight = minSize.height;
        }
    }
}
