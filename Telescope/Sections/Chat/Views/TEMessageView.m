//
//  TEMessageContentView.m
//  Telescope
//
//  Created by zhangguang on 16/12/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEMessageView.h"
#import "TETextLayoutView.h"

@interface TEMessageView ()

@property (nonatomic,strong) TETextLayoutView* layoutView;

@end


@implementation TEMessageView

#pragma mark - *** Properties ***
- (TETextLayoutView*)layoutView
{
    if (!_layoutView) {
        _layoutView = [[TETextLayoutView alloc] init];
    }
    return _layoutView;
}

#pragma mark - *** Initializer ***

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.layoutView];
    }
    return self;
}

- (void)layoutSubviews
{
    //_layoutView.frame = CGRectMake(12, 4, self.width - 6, self.height - 12);
    _layoutView.frame = CGRectMake(_contentInset.left, _contentInset.top, self.width - _contentInset.right, self.height - _contentInset.bottom);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
