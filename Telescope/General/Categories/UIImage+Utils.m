//
//  UIImage+Utils.m
//  Telescope
//
//  Created by zhangguang on 17/1/24.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import "UIImage+Utils.h"


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



@implementation UIImage (Utils)

- (void)produceThumbnailInPath:(NSString*)path
                       minSize:(CGSize)minSize
                       maxSize:(CGSize)maxSize
                      fileName:(NSString*)fileName
{
    BOOL isDirectory = YES;
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory], @"存储路径不存在") ;
    CGImageRef aspectImg = self.CGImage;
    CGFloat width = CGImageGetWidth(aspectImg);
    CGFloat height = CGImageGetHeight(aspectImg);
    aspectSizeInContainer(&width, &height, minSize, maxSize);
    
    
    CGSize imageSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(imageSize);
    UIImage* thumbnailImage = [UIImage imageWithCGImage:aspectImg];
    [thumbnailImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSString* thumbnailImagePath = [path stringByAppendingPathComponent:fileName];
    NSData* thumbnailJPGData = UIImageJPEGRepresentation(resultImage, 1);

    [thumbnailJPGData writeToFile:thumbnailImagePath atomically:YES];
}


@end
