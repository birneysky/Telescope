//
//  CALayer+Additions.h
//  StoryBoardTest
//
//  Created by birneysky on 15/6/3.
//  Copyright (c) 2015年 birneysky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (Additions)


/**
 根据UIColor设置Layer的边框颜色

 @param color 颜色对象实例
 */
-(void)setBorderColorFromUIColor:(UIColor*)color;


/**
 根据UIcolor设置layer的阴影颜色

 @param color 颜色对象实例
 */
- (void)setShadowColorFromUIColor:(UIColor*)color;

@end
