//
//  TEBroadcastLiveViewController.m
//  Telescope
//
//  Created by zhangguang on 16/11/17.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEBroadcastLiveViewController.h"
#import <V2Kit/V2Kit.h>
#import <AVFoundation/AVFoundation.h>
#import "TENetworkKit.h"

@interface TEBroadcastLiveViewController () <ShowDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (weak, nonatomic) IBOutlet UIView *liveVideoView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *remoteVideoView1;
@property (weak, nonatomic) IBOutlet UIView *remoteVideoView2;
@property (weak, nonatomic) IBOutlet UIButton *golivewBtn;

@property (nonatomic,assign) BOOL video1isOpen;
@property (nonatomic,assign) BOOL viddeo2isOpen;
@property (nonatomic,assign) long long user1;
@property (nonatomic,assign) long long user2;


/**
 是否已经进入直播间
 */
@property (nonatomic,assign) BOOL isEnterShow;

@property (nonatomic,assign) long long showID;

@end

@implementation TEBroadcastLiveViewController

- (void)dealloc
{
    NSLog(@"♻️♻️♻️♻️ TEBroadcastLiveViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backgroundImageView.image = self.backgroundImage;

    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    
    [V2Kit defaultKit].showDelegate = self;
    
    if (!self.communicateWithAnchor) {
        [[V2Kit defaultKit] openCameraWithRenderView:self.liveVideoView useFrontCamera:YES];
    }
    else{
        [[V2Kit defaultKit] quickEnterShow:30 userID:self.userID showRole:ROLE_TYPE_PARTICIPANT];
    }
    
    UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.videoView addGestureRecognizer:recognizer];
    NSLog(@"reference count = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));
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

#pragma mark - *** Helper ***
- (void)destroyShow
{
    //[[V2Kit defaultKit] closeCamera];
    NSString* deviceID = [NSString stringWithFormat:@"%lld:Camera",self.userID];
    [[V2Kit defaultKit] videoCloseDevice:self.userID deviceID:deviceID videoView:self.liveVideoView];
    if (self.video1isOpen) {
        deviceID = [NSString stringWithFormat:@"%lld:Camera",self.user1];
        [[V2Kit defaultKit] videoCloseDevice:self.user1 deviceID:deviceID videoView:self.remoteVideoView1];
    }
    else if(self.viddeo2isOpen){
        deviceID = [NSString stringWithFormat:@"%lld:Camera",self.user2];
        [[V2Kit defaultKit] videoCloseDevice:self.user2 deviceID:deviceID videoView:self.remoteVideoView2];
    }
    //if (self.showID > 0)
    [[V2Kit defaultKit] exitShow:self.showID];
    [V2Kit defaultKit].showDelegate = nil;
    NSLog(@"reference count = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));
}

- (void)publishShow
{
//    TELiveShowInfo* liveShowInfo = [[TELiveShowInfo alloc] init];
//    liveShowInfo.liveId = self.showID;
//    liveShowInfo.coordinate = CLLocationCoordinate2DMake(45.050167031573309, 86.942400392959328);
//    [TENETWORKKIT publishShowInfo:liveShowInfo completion:^{
//        
//    } onError:^(NSError *error) {
//        
//    }];
}


#pragma mark - *** Target Action ***
- (IBAction)closeBtnClicked:(id)sender {
    __weak TEBroadcastLiveViewController* weakSelf = self;
    [weakSelf dismissViewControllerAnimated:YES completion:^{
        [weakSelf destroyShow];
    }];
}

- (IBAction)goLiveBtnClicked:(id)sender {
    [[V2Kit defaultKit] quickEnterShow:30 userID:self.userID showRole:ROLE_TYPE_CHAIRMAN];
     NSLog(@"reference count = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));
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
    NSLog(@"targetPoint %@",NSStringFromCGPoint(point));
    self.videoView.center = CGPointMake(self.videoView.center.x, self.videoView.center.y + point.y);
    if(self.videoView.frame.origin.y <= 0){
        self.videoView.center = self.view.center;
        return;
    }
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

                             [self dismissViewControllerAnimated:NO completion:^{
                                 [self destroyShow];
                             }];
                         }
                     }
     ];
}

#pragma mark - *** ShowDelegate ***
- (void)onEnterShow:(long long)showId showInfoXml:(NSString *)xml code:(NSInteger)code
{

      NSLog(@"reference count = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));
    self.showID = showId;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = xml;
        
        if(0 == code){
            self.isEnterShow = YES;
            self.golivewBtn.hidden = YES;
            [self publishShow];
        }
        else{
            [self.golivewBtn setTitle:@"Go Live Failed" forState:UIControlStateNormal];
            self.golivewBtn.backgroundColor = [UIColor redColor];
        }
        //
        if (!self.communicateWithAnchor) {
            [[V2Kit defaultKit] uploadVideo:self.userID];
        }
        else{
            NSString* deviceID = [NSString stringWithFormat:@"%lld:Camera",self.userID];
            [[V2Kit defaultKit] videoOpenDevice:self.userID deviceID:deviceID videoView:self.liveVideoView];
        }
        
        //[[V2Kit defaultKit] videoSwitchCamera:self.videoView];
    });
    
}



-  (void) onMemberEnterShow:(long long)showId userID:(long long)uid userInfoXml:(NSString*)xml
{
    NSString* deviceID = [NSString stringWithFormat:@"%lld:Camera",uid];
    dispatch_async(dispatch_get_main_queue(), ^{
//        if (self.communicateWithAnchor) {
//            [[V2Kit defaultKit] videoOpenDevice:uid deviceID:deviceID videoView:self.liveVideoView];
//        }
         if(!self.video1isOpen){
            [[V2Kit defaultKit] videoOpenDevice:uid deviceID:deviceID videoView:self.remoteVideoView1];
            self.video1isOpen = YES;
            self.remoteVideoView1.hidden = NO;
             self.user1 = uid;
        }
        else if(!self.viddeo2isOpen){
            [[V2Kit defaultKit] videoOpenDevice:uid deviceID:deviceID videoView:self.remoteVideoView2];
            self.viddeo2isOpen = YES;
            self.remoteVideoView2.hidden = NO;
            self.user2 = uid;
        }
       
    });
    
}

-  (void) onMemberExitShow:(long long)showId userID:(long long) nUserID
{
    NSString* deviceID = [NSString stringWithFormat:@"%lld:Camera",nUserID];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.user1 == nUserID) {
            [[V2Kit defaultKit] videoCloseDevice:nUserID deviceID:deviceID videoView:self.remoteVideoView1];
            self.user1 = 0;
            self.remoteVideoView1.hidden = YES;
            self.video1isOpen = NO;
        }
        else if(self.user2 == nUserID){
            [[V2Kit defaultKit] videoCloseDevice:nUserID deviceID:deviceID videoView:self.remoteVideoView2];
            self.user2 = 0;
            self.remoteVideoView2.hidden = YES;
            self.viddeo2isOpen = NO;
        }
    });
    
}

- (void)onKickConf
{
    
}

-  (void) onNotifyConf:(NSString*) showInfoXml userInfoXml:(NSString*)xml
{
    
}


- (void)onConfMute
{
    
}

@end
