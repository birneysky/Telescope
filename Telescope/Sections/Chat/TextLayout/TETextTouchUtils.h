//
//  TETextTouchUtils.h
//  Telescope
//
//  Created by zhangguang on 16/12/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TETextLayoutModel.h"

@interface TETextTouchUtils : NSObject

+ (id<TETextLinkModel>)touchLinkInView:(UIView *)view atPoint:(CGPoint)point layoutModel:(TETextLayoutModel *)model;

+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point layoutModel:(TETextLayoutModel *)model;

@end
