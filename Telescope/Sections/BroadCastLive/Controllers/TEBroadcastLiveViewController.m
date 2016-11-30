//
//  TEBroadcastLiveViewController.m
//  Telescope
//
//  Created by zhangguang on 16/11/17.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEBroadcastLiveViewController.h"

#import <V2Kit/V2Kit.h>

@interface TEBroadcastLiveViewController () <ShowDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (weak, nonatomic) IBOutlet UIView *liveVideoView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation TEBroadcastLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backgroundImageView.image = self.backgroundImage;


    
    [V2Kit defaultKit].showDelegate = self;
    [[V2Kit defaultKit] openCameraWithRenderView:self.liveVideoView useFrontCamera:YES];
    
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
        [[V2Kit defaultKit] closeCamera];
    }];
}

- (IBAction)goLiveBtnClicked:(id)sender {
    [[V2Kit defaultKit] quickEnterShow:30 userID:88 showRole:ROLE_TYPE_CHAIRMAN];
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
                             [[V2Kit defaultKit] closeCamera];
                             [self dismissViewControllerAnimated:NO completion:nil];
                         }
                     }
     ];
}

#pragma mark - *** ShowDelegate ***
- (void)onEnterShow:(long long)showId showInfoXml:(NSString *)xml code:(NSInteger)code
{
   dispatch_async(dispatch_get_main_queue(), ^{
       self.statusLabel.text = xml;
//       NSString* deviceID = [NSString stringWithFormat:@"%lld:Camera",(long long)88];
//       [[V2Kit defaultKit] videoOpenDevice:88 deviceID:deviceID videoView:self.liveVideoView];
       [[V2Kit defaultKit] uploadVideo:88];
        //[[V2Kit defaultKit] videoSwitchCamera:self.videoView];
    });
    
    
    
}

-  (void) onMemberEnterShow:(long long)showId userID:(long long)uid userInfoXml:(NSString*)xml
{
//    NSString* deviceID = [NSString stringWithFormat:@"%lld:Camera",uid];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[V2Kit defaultKit] videoOpenDevice:uid deviceID:deviceID videoView:self.remoteVideoView];
//    });
    
}

-  (void) onMemberExitShow:(long long)showId userID:(long long) nUserID
{
//    NSString* deviceID = [NSString stringWithFormat:@"%lld:Camera",nUserID];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[V2Kit defaultKit] videoCloseDevice:nUserID deviceID:deviceID videoView:self.remoteVideoView];
//    });
    
}
@end
