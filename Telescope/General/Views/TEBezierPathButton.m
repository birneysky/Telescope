//
//  TEBezierPathButton.m
//  Telescope
//
//  Created by zhangguang on 16/10/27.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEBezierPathButton.h"

@implementation TEBezierPathButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(self.bounds.size.height / 2, self.bounds.size.height / 2)];
    CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = maskPath.CGPath;
    self.layer.mask = shapeLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
