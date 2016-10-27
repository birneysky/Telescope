//
//  CALayer+Additions.m
//  StoryBoardTest
//
//  Created by birneysky on 15/6/3.
//  Copyright (c) 2015年 birneysky. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)

-(void)setBorderColorFromUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

- (void)setShadowColorFromUIColor:(UIColor*)color
{
    self.shadowColor = color.CGColor;
}

@end
