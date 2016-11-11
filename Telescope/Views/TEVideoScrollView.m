//
//  TEVideoScrollView.m
//  Telescope
//
//  Created by zhangguang on 16/11/10.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEVideoScrollView.h"
#import "TEVideoPlayer.h"

#define kTEVideoPlayerCount 3

@interface TEVideoScrollView () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView* scrollView;

@end

@implementation TEVideoScrollView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubview:self.scrollView];
    }
    return self;
}

#pragma mark - *** Properties ***


- (UIScrollView*) scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
       // _scrollView.showsVerticalScrollIndicator = NO;
       // _scrollView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < kTEVideoPlayerCount; i++) {
            TEVideoPlayer* player = [[TEVideoPlayer alloc] init];
            [_scrollView addSubview:player];
        }
    }
    
    return _scrollView;
}

#pragma mark - *** Override ***
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    self.scrollView.frame = self.bounds;
    
    for (int i = 0; i < kTEVideoPlayerCount; i++) {
        TEVideoPlayer* player = self.scrollView.subviews[i];
        player.frame = CGRectMake(i * selfWidth, 0, selfWidth, selfHeight);
    }
    
    self.scrollView.contentSize = CGSizeMake(selfWidth * kTEVideoPlayerCount, selfHeight);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - *** UIScrollViewDelegate ***
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"☔️☔️☔️☔️☔️☔️ contentOffset %@ contentSize %@ ",NSStringFromCGPoint(self.scrollView.contentOffset),NSStringFromCGSize(self.scrollView.contentSize));
}

@end
