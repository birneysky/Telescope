//
//  TEVideoPlayer.m
//  Telescope
//
//  Created by zhangguang on 16/11/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface TEVideoPlayer ()//<IJKPlayerDelegate>


@property (nonatomic,strong) NSArray<NSString*>* rtmpUrl;

@property (nonatomic,strong) UIActivityIndicatorView* indicator;

@property (nonatomic,strong) IJKFFMoviePlayerController* ijkPlayerController;

@end

@implementation TEVideoPlayer
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    
    NSLog(@"♻️♻️♻️♻️ TEVideoPlayer ~ %@ ",self);
}

- (void)layoutSubviews
{
    self.indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

#pragma mark - *** Properties ***


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

- (IJKFFMoviePlayerController*)ijkPlayerController
{
    if (!_ijkPlayerController) {
        //_ijkPlayerController = [[IJKFFMoviePlayerController alloc] initWithOptions:[IJKFFOptions optionsByDefault]];
        _ijkPlayerController = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"] withOptions:[IJKFFOptions optionsByDefault]];
        _ijkPlayerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _ijkPlayerController.view.frame = self.bounds;
        _ijkPlayerController.scalingMode = IJKMPMovieScalingModeAspectFit;
        _ijkPlayerController.shouldAutoplay = YES;
        //_ijkPlayerController.delegate  = self;
        [self addPlayerNotificationObservers];
    }
    return _ijkPlayerController;
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
    //[self.guestKit StartRtmpPlay:url andRender:self];
    
    if (!self.ijkPlayerController.view.superview) {
        [self addSubview:self.ijkPlayerController.view];
    }
   // [self.ijkPlayerController setUrl:url];
    [self.ijkPlayerController prepareToPlay];
}

- (void)stopRtmpPlay
{
    //[self.guestKit StopRtmpPlay];
    [self.ijkPlayerController shutdown];
    [self removeMovieNotificationObservers];
   // [self.ijkPlayerController stop];

}



//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    CGRect rect =  AVMakeRectWithAspectRatioInsideRect(CGSizeMake(640, 480),self.bounds);
//    self.guestKit.player.frame = rect;
//}

#pragma mark - ***Gesture Action ***

- (void)didPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self.superview];
    self.center = CGPointMake(self.center.x + point.x, self.center.y);
    [recognizer setTranslation:CGPointZero inView:self.superview];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.superview];
        [self startAnimatingWithInitialVelocity:velocity];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint velocity = [recognizer velocityInView:self.superview];
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan) {
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
                             self.automaticallySwitchToTheNext = YES;
                             [self stopRtmpPlay];
                             CGSize size = self.bounds.size;
                             self.center = CGPointMake(size.width / 2, size.height / 2);
                             [self showIndicator];
//                             NSInteger index = arc4random() %3;
//                             NSString* url = self.rtmpUrl[index];
//                             [self startRtmpPlayWithUrl:url];
                         }
                     }
     ];
}

#pragma mark - *** notification selector ***
- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = self.ijkPlayerController.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        [self hideIndicator];
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        [self showIndicator];
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    IJKMPMoviePlaybackState state = self.ijkPlayerController.playbackState;
    
    switch (state)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)state);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)state);
            [self hideIndicator];
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)state);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)state);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)state);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)state);
            break;
        }
    }
}


#pragma mark - *** add notification ***
-(void)addPlayerNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:self.ijkPlayerController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:self.ijkPlayerController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:self.ijkPlayerController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.ijkPlayerController];
}

#pragma mark - *** remove notification  ***

-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.ijkPlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.ijkPlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.ijkPlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:self.ijkPlayerController];
}

#pragma mark - *** IJKPlayerDelegate ***
- (void)didShutDown
{
    [self.ijkPlayerController.view removeFromSuperview];
    self.ijkPlayerController = nil;
    if (self.automaticallySwitchToTheNext) {
        NSString* url = self.rtmpUrl[arc4random() % self.rtmpUrl.count];
        [self startRtmpPlayWithUrl:url];
        //[self showIndicator];
    }
}


@end
