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

-(void)setBorderColorFromUIColor:(UIColor*)color;

- (void)setShadowColorFromUIColor:(UIColor*)color;

@end
