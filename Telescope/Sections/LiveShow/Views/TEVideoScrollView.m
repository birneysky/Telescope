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

//scrollView的宽度
#define kTEScrollView_Width self.scrollView.frame.size.width
//scrollView的高度
#define kTEScrollView_Height self.scrollView.frame.size.height

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
            if (0 == i) {
                player.backgroundColor = [UIColor orangeColor];
            }
            else if(1 == i){
                player.backgroundColor = [UIColor purpleColor];
            }
            else{
                player.backgroundColor = [UIColor grayColor];
            }
            
        }
    }
    
    return _scrollView;
}

- (NSArray<NSString*>*) rtmpUrl{
    if (!_rtmpUrl) {
        _rtmpUrl = @[@"rtmp://203.207.99.19:1935/live/zgjyt",@"rtmp://live.hkstv.hk.lxdns.com/live/hks",@"rtmp://124.128.26.173/live/jnyd_sd"];
    }
    return _rtmpUrl;
}

#pragma mark - *** Override ***
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    
    for (int i = 0; i < kTEVideoPlayerCount; i++) {
        TEVideoPlayer* player = self.scrollView.subviews[i];
        player.frame = CGRectMake(i * kTEScrollView_Width, 0, kTEScrollView_Width, kTEScrollView_Height);
        
        //player.bounds =CGRectMake(0, 0, kTEScrollView_Width, kTEScrollView_Height);
    }
    
    
    self.scrollView.contentSize = CGSizeMake(kTEScrollView_Width * kTEVideoPlayerCount, kTEScrollView_Height);
    self.scrollView.contentOffset = CGPointMake(kTEScrollView_Width, 0);
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
    TEVideoPlayer* player = self.scrollView.subviews[1];
    [player startRtmpPlayWithUrl:self.rtmpUrl[1]];
}

#pragma mark - *** Helper ***
- (void)setupScrollViewContentSize
{
    self.scrollView.contentSize = CGSizeMake(kTEScrollView_Width * kTEVideoPlayerCount, 0);
}


-(UIColor*)randomColor
{
    switch (arc4random() % 5) {
        case 0:return [UIColor greenColor];
        case 1:return [UIColor blueColor];
        case 2:return [UIColor orangeColor];
        case 3:return [UIColor redColor];
        case 4:return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}

@end
