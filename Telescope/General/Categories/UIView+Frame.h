//
//  UIView+Frame.h
//  WeChat
//
//  Created by zhangguang on 16/3/21.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic,assign) CGPoint origin;

@property (nonatomic,assign) CGFloat x;

@property (nonatomic,assign) CGFloat y;

@property (nonatomic,assign) CGFloat width;

@property (nonatomic,assign) CGFloat height;

@property (nonatomic,readonly) CGPoint leftTop;

@property (nonatomic,readonly) CGPoint rightTop;

@property (nonatomic,readonly) CGPoint leftBottom;

@property (nonatomic,readonly) CGPoint rightBottom;

@end
