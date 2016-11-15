//
//  TEVideoPlayer.m
//  Telescope
//
//  Created by zhangguang on 16/11/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEVideoPlayer.h"
#import <TEPlayerKit/TEPlayerKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TEVideoPlayer ()<RTMPGuestRtmpDelegate>

@property (nonatomic, strong) RTMPGuestKit *guestKit;

@property (nonatomic,strong) NSArray<NSString*>* rtmpUrl;

@property (nonatomic,strong) UIActivityIndicatorView* indicator;


@end

@implementation TEVideoPlayer
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    self.indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

#pragma mark - *** Properties ***
- (RTMPGuestKit*)guestKit
{
    if (!_guestKit) {
        _guestKit = [[RTMPGuestKit alloc] initWithDelegate:self];
    }
    return _guestKit;
}

- (NSArray<NSString*>*) rtmpUrl{
    if (!_rtmpUrl) {
        _rtmpUrl = @[@"rtmp://live.hkstv.hk.lxdns.com/live/hks",@"rtmp://203.207.99.19:1935/live/zgjyt",@"rtmp://203.207.99.19:1935/live/CCTV5"];
    }
    return _rtmpUrl;
}

- (UIActivityIndicatorView*)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //_indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height);
    }
    return _indicator;
}

#pragma mark - *** Helper ***
- (void)setup
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self addGestureRecognizer:recognizer];
}

- (void)showIndicator
{
    if (!self.indicator.superview) {
        [self addSubview:self.indicator];
        [self.indicator  startAnimating];
    }
    
    [self bringSubviewToFront:self.indicator];
    NSLog(@"❄️❄️❄️❄️❄️❄️❄️❄️❄️");
}

- (void)hideIndicator
{
    if (!self.indicator.superview) {
        return;
    }
    else{
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
    }

    NSLog(@"🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯");
}

#pragma mark - *** Api ***
- (void)startRtmpPlayWithUrl:(NSString *)url
{
NSLog(@"layoutBefore TEVideoPlayer bounds %@, frame %@",NSStringFromCGRect(self.bounds),NSStringFromCGRect(self.frame));
    // [self layoutIfNeeded];
    NSLog(@"layoutAfter TEVideoPlayer bounds %@, frame %@",NSStringFromCGRect(self.bounds),NSStringFromCGRect(self.frame));
    [self.guestKit StartRtmpPlay:url andRender:self];
}

- (void)stopRtmpPlay
{
    [self.guestKit StopRtmpPlay];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    CGRect rect =  AVMakeRectWithAspectRatioInsideRect(CGSizeMake(640, 480),self.bounds);
//    self.guestKit.player.frame = rect;
//}

#pragma mark - *** RTMPGuestRtmpDelegate ***
- (void)OnRtmplayerOK {
    NSLog(@"OnRtmpStreamOK");
    //self.stateRTMPLabel.text = @"连接RTMP服务成功";
}
- (void)OnRtmplayerStatus:(int) cacheTime withBitrate:(int) curBitrate {
    NSLog(@"OnRtmplayerStatus:%d withBitrate:%d",cacheTime,curBitrate);
    //self.stateRTMPLabel.text = [NSString stringWithFormat:@"RTMP缓存区:%d 码率:%d",cacheTime,curBitrate];
    if (cacheTime > 0 && curBitrate > 0) {
        [self hideIndicator];
    }
}
- (void)OnRtmplayerCache:(int) time {
  NSLog(@"OnRtmplayerCache:%d",time);
//self.stateRTMPLabel.text = [NSString stringWithFormat:@"RTMP正在缓存:%d",time];
    [self showIndicator];

}

- (void)OnRtmplayerClosed:(int) errcode {
    NSLog(@"🌺🌺🌺🌺🌺🌺🌺OnRtmplayerClosed");
    NSString* url = self.rtmpUrl[arc4random() % self.rtmpUrl.count];
    [self startRtmpPlayWithUrl:url];
    [self showIndicator];
}

#pragma mark - ***Gesture Action ***

- (void)didPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self.superview];
    self.center = CGPointMake(self.center.x + point.x, self.center.y);
    [recognizer setTranslation:CGPointZero inView:self.superview];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.superview];
        NSLog(@"Ended velocity %@",NSStringFromCGPoint(velocity));
        //velocity.x = 0;
        velocity.y = 0;
        //[self.delegate draggableView:self draggingEndedWithVelocity:velocity];
        //self.translatesAutoresizingMaskIntoConstraints = YES;
        //[self layoutIfNeeded];
        [self startAnimatingWithInitialVelocity:velocity];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint velocity = [recognizer velocityInView:self.superview];
        NSLog(@"Changed velocity %@",NSStringFromCGPoint(velocity));
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan) {
        //self.translatesAutoresizingMaskIntoConstraints = NO;
        //[self.delegate draggableViewBeganDragging:self];
    }
}



- (void)startAnimatingWithInitialVelocity:(CGPoint)initialVelocity
{
    CGPoint targetPoint = CGPointZero;
    CGSize size = self.bounds.size;
    
    BOOL next = YES;
    
    if (initialVelocity.x >=100) {
        targetPoint = CGPointMake(size.width/2  + size.width, self.center.y);
    }
    else if(initialVelocity.x <= -100){
        targetPoint = CGPointMake(size.width/2 - size.width , self.center.y);
    }
    else{
        targetPoint = CGPointMake(size.width / 2, self.center.y);
        next = NO;
    }
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:4.0
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.center = targetPoint;
                     }
                     completion:^(BOOL finished) {
                         if(next){
                             [self stopRtmpPlay];
                             CGSize size = self.bounds.size;
                             self.center = CGPointMake(size.width / 2, size.height / 2);
                             [self showIndicator];
                         }
                     }
     ];
}


@end
