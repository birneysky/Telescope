//
//  TEBroadcastLiveViewController.m
//  Telescope
//
//  Created by zhangguang on 16/11/17.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEBroadcastLiveViewController.h"

#import <V2Kit/V2Kit.h>

@interface TEBroadcastLiveViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (weak, nonatomic) IBOutlet UIView *liveVideoView;
@end

@implementation TEBroadcastLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backgroundImageView.image = self.backgroundImage;
    [[V2Kit defaultKit] videoOpenDevice:0 deviceID:@"0:Camera" videoView:self.liveVideoView];
    
    UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.videoView addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - *** Target Action ***
- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - *** Override  orientation ***
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


#pragma mark - *** Override  Statusbar***

//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}


#pragma mark - ***Gesture Selector ***
- (void)didPan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer translationInView:self.view];
    self.videoView.center = CGPointMake(self.videoView.center.x, self.videoView.center.y + point.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint veloity = [recognizer velocityInView:self.view];
        [self startAnimatingWithInitialVelocity:veloity];
    }
}

- (void)startAnimatingWithInitialVelocity:(CGPoint)initialVelocity
{
    CGPoint targetPoint = CGPointZero;
    CGSize size = self.view.bounds.size;

    BOOL leaveScreen = NO;
    if (initialVelocity.y >=100) {
        targetPoint = CGPointMake(self.videoView.center.x, size.height / 2 + size.height);
        leaveScreen = YES;
    }
    else{
        targetPoint = CGPointMake(self.videoView.center.x, size.height / 2);
    }
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:4.0
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.videoView.center = targetPoint;
                     }
                     completion:^(BOOL finished) {
                         if(leaveScreen){
                             //[self stopRtmpPlay];
                             //CGSize size = self.bounds.size;
                             //self.center = CGPointMake(size.width / 2, size.height / 2);
                             //[self showIndicator];
                             [self dismissViewControllerAnimated:NO completion:nil];
                         }
                     }
     ];
}

@end
