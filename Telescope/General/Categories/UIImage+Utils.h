//
//  UIImage+Utils.h
//  Telescope
//
//  Created by zhangguang on 17/1/24.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import <UIKit/UIKit.h>


void aspectSizeInContainer(CGFloat* sourceWidth,CGFloat* sourceHeight,CGSize minSize,CGSize maxSize);


@interface UIImage (Utils)

/**
 生成某一个图片的等比例缩略图

 @param path 有效存放路径
 @param minSize 缩略图的最小尺寸
 @param maxSize 缩略图的最大尺寸
 @param fileName 生成缩略图的文件名
 
 该函数还不够完善，未指定生成缩略图的格式，默认是生成jpg格式，先这样写吧 
 */
- (void)produceThumbnailInPath:(NSString*)path
                       minSize:(CGSize)minSize
                       maxSize:(CGSize)maxSize
                      fileName:(NSString*)fileName;

@end
