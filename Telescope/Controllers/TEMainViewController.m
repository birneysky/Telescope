//
//  MainViewController.m
//  Telescope
//
//  Created by zhangguang on 16/10/28.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEMainViewController.h"
#import "TEDefaultCollectionController.h"
#import "TEDefaultCollectionCell.h"
#import <MapKit/MapKit.h>

#import "TENetworkKit.h"

#import "TEVideoPlayer.h"

@interface TEMainViewController ()
@property (strong, nonatomic) IBOutlet TEDefaultCollectionController *userCollectionController;
@property (nonatomic, strong) NSArray<TELiveShowInfo*>* lives;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoPlayerWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoPlayerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoPlayerYConstraint;


/**
 上一次设备的方向
 */
@property (nonatomic,assign) UIDeviceOrientation previousDeviceOrientation;

/**
 旋转的角度的倍数
 */
@property (nonatomic,assign)  NSInteger angleRation;

/**
 是否重置视图大小
 */
@property (nonatomic,assign) BOOL resizeFlag;


@end

@implementation TEMainViewController

- (void)dealloc
{
    NSLog(@"♻️♻️♻️♻️ TEMainViewController ~ %@ ",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.userCollectionController registerWithNibName:@"TEDefaultCollectionCell"
                            forCellWithReuseIdentifier:@"te_default_collection_cell_id"];
    
    /*
     rtmp://203.207.99.19:1935/live/CCTV5   体育频道
     rtmp://203.207.99.19:1935/live/CCTV1
     rtmp://203.207.99.19:1935/live/CCTV2
     rtmp://203.207.99.19:1935/live/CCTV4
     rtmp://203.207.99.19:1935/live/CCTV7
     rtmp://203.207.99.19:1935/live/CCTV10
     rtmp://203.207.99.19:1935/live/CCTV12
     rtmp://live.hkstv.hk.lxdns.com/live/hks 香港卫视
     rtmp://203.207.99.19:1935/live/zgjyt  湖南卫视
     rtmp://124.128.26.173/live/jnyd_sd  济南卫视
     */
    NSArray<NSString*>* rtmps = @[@"rtmp://203.207.99.19:1935/live/zgjyt",@"rtmp://203.207.99.19:1935/live/CCTV1",@"",@"rtmp://203.207.99.19:1935/live/CCTV2",@"rtmp://203.207.99.19:1935/live/CCTV4",@"rtmp://203.207.99.19:1935/live/CCTV7",@"rtmp://203.207.99.19:1935/live/CCTV10",@"rtmp://203.207.99.19:1935/live/CCTV12",@"rtmp://203.207.99.19:1935/live/CCTV5"];
    [TENETWORKKIT fetchLiveShowListWithCompletion:^(TEResponse<NSArray<TELiveShowInfo *> *> *response) {
        NSArray<TELiveShowInfo*>* array = response.body;
        [array enumerateObjectsUsingBlock:^(TELiveShowInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.liveStreamingAddress = rtmps[idx];
        }];
        self.lives = array;
    } onError:^(NSError *error) {
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    self.previousDeviceOrientation = UIDeviceOrientationPortrait;
    self.angleRation = 0;
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    self.playerWidthConstraint.constant = screenSize.width;
//    self.playerHeightConstraint.constant = screenSize.height;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - *** Target Action ****
- (IBAction)cancelBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)fullscreenBtnClicked:(UIButton*)sender {
    if (sender.selected) {
        [self rotateVideoViewFromOrientation:self.previousDeviceOrientation ToOrientation:UIDeviceOrientationPortrait];
    }
    else{
        [self rotateVideoViewFromOrientation:self.previousDeviceOrientation ToOrientation:UIDeviceOrientationLandscapeLeft];
        
    }
    sender.selected = !sender.selected;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - *** notification selector ***
- (void)DeviceOrientationDidChange:(NSNotification*)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (deviceOrientation < UIDeviceOrientationPortrait ||
        deviceOrientation > UIDeviceOrientationLandscapeRight ||
        deviceOrientation == UIDeviceOrientationPortraitUpsideDown ) {
        return;
    }
    
    [self rotateVideoViewFromOrientation:self.previousDeviceOrientation ToOrientation:deviceOrientation];
    
//    if (deviceOrientation != UIDeviceOrientationPortrait) {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }
//    else{
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
//    self.resizeFlag = NO;
//    if((self.previousDeviceOrientation == UIDeviceOrientationPortrait &&
//        deviceOrientation == UIDeviceOrientationLandscapeLeft) ||
//       (self.previousDeviceOrientation == UIDeviceOrientationLandscapeLeft &&
//        deviceOrientation == UIDeviceOrientationPortraitUpsideDown)||
//       (self.previousDeviceOrientation == UIDeviceOrientationPortraitUpsideDown &&
//        deviceOrientation == UIDeviceOrientationLandscapeRight) ||
//       (self.previousDeviceOrientation == UIDeviceOrientationLandscapeRight &&
//        deviceOrientation == UIDeviceOrientationPortrait)){
//           self.angleRation ++;
//           self.resizeFlag = YES;
//       }
//    if ((self.previousDeviceOrientation == UIDeviceOrientationPortrait &&
//         deviceOrientation == UIDeviceOrientationLandscapeRight) ||
//        (self.previousDeviceOrientation == UIDeviceOrientationLandscapeRight &&
//         deviceOrientation == UIDeviceOrientationPortraitUpsideDown) ||
//        (self.previousDeviceOrientation == UIDeviceOrientationPortraitUpsideDown &&
//         deviceOrientation == UIDeviceOrientationLandscapeLeft) ||
//        (self.previousDeviceOrientation == UIDeviceOrientationLandscapeLeft &&
//         deviceOrientation == UIDeviceOrientationPortrait)) {
//            self.angleRation --;
//            self.resizeFlag = YES;
//        }
//    
//    
//    if ((self.previousDeviceOrientation == UIDeviceOrientationPortrait &&
//         deviceOrientation == UIDeviceOrientationPortraitUpsideDown)||
//        (self.previousDeviceOrientation == UIDeviceOrientationLandscapeLeft &&
//         deviceOrientation == UIDeviceOrientationLandscapeRight)) {
//            self.angleRation += 2;
//        }
//    
//    
//    if ((self.previousDeviceOrientation == UIDeviceOrientationPortraitUpsideDown &&
//         deviceOrientation == UIDeviceOrientationPortrait) ||
//        (self.previousDeviceOrientation == UIDeviceOrientationLandscapeRight &&
//         deviceOrientation == UIDeviceOrientationLandscapeLeft)) {
//            self.angleRation -= 2;
//        }
//    
//
//    [UIView animateWithDuration:0.5
//                          delay:0.0
//         usingSpringWithDamping:0.9
//          initialSpringVelocity:4.0
//                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         if (self.resizeFlag) {
//                             if (deviceOrientation != UIDeviceOrientationPortrait) {
//                                 self.videoPlayerYConstraint.constant = 0;
//                                 self.videoPlayerWidthConstraint.constant = [UIScreen mainScreen].bounds.size.height;
//                                 self.videoPlayerHeightConstraint.constant = [UIScreen mainScreen].bounds.size.width;
//                             }
//                             else{
//                                 
//                                 self.videoPlayerYConstraint.constant = -128;
//                                 NSLog(@"videPlayer height %lf,%lf",([UIScreen mainScreen].bounds.size.width * 3 ) / 4.0f,floor(([UIScreen mainScreen].bounds.size.width * 3) / 4.0f));
//                                 self.videoPlayerHeightConstraint.constant = floor(([UIScreen mainScreen].bounds.size.width * 3 ) / 4.0f);
//                                 self.videoPlayerWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width;
//                             }
//                             [self.videoView layoutIfNeeded];
//                         }
//                         self.videoView.transform =  CGAffineTransformMakeRotation( M_PI * self.angleRation / 2);
//        }
//        completion:^(BOOL finished) {
//        }];
// 
//
//    
//    //NSInteger differValue = deviceOrientation - self.previousDeviceOrientation;
//    //NSLog(@"previous %d, current %d, differVaue = %d,angleRation = %d",self.previousDeviceOrientation, deviceOrientation,differValue,_angleRation);
//    self.previousDeviceOrientation = deviceOrientation;
}

#pragma mark - **** Helper ****
- (void)rotateVideoViewFromOrientation:(UIDeviceOrientation) fOrientation ToOrientation:(UIDeviceOrientation) tOrientation{
    
    if (tOrientation != UIDeviceOrientationPortrait) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    self.resizeFlag = NO;
    if((fOrientation == UIDeviceOrientationPortrait && tOrientation == UIDeviceOrientationLandscapeLeft) ||
       (fOrientation == UIDeviceOrientationLandscapeLeft && tOrientation == UIDeviceOrientationPortraitUpsideDown)||
       (fOrientation == UIDeviceOrientationPortraitUpsideDown && tOrientation == UIDeviceOrientationLandscapeRight) ||
       (fOrientation == UIDeviceOrientationLandscapeRight && tOrientation == UIDeviceOrientationPortrait)){
           self.angleRation ++;
           self.resizeFlag = YES;
       }
    if ((fOrientation == UIDeviceOrientationPortrait && tOrientation == UIDeviceOrientationLandscapeRight) ||
        (fOrientation == UIDeviceOrientationLandscapeRight && tOrientation == UIDeviceOrientationPortraitUpsideDown) ||
        (fOrientation == UIDeviceOrientationPortraitUpsideDown && tOrientation == UIDeviceOrientationLandscapeLeft) ||
        (fOrientation == UIDeviceOrientationLandscapeLeft && tOrientation == UIDeviceOrientationPortrait)) {
            self.angleRation --;
            self.resizeFlag = YES;
        }
    
    
    if ((fOrientation == UIDeviceOrientationPortrait && tOrientation == UIDeviceOrientationPortraitUpsideDown)||
        (fOrientation == UIDeviceOrientationLandscapeLeft && tOrientation == UIDeviceOrientationLandscapeRight)) {
            self.angleRation += 2;
        }
    
    
    if ((fOrientation == UIDeviceOrientationPortraitUpsideDown && tOrientation == UIDeviceOrientationPortrait) ||
        (fOrientation == UIDeviceOrientationLandscapeRight && tOrientation == UIDeviceOrientationLandscapeLeft)) {
            self.angleRation -= 2;
        }
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:4.0
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (self.resizeFlag) {
                             if (tOrientation != UIDeviceOrientationPortrait) {
                                 self.videoPlayerYConstraint.constant = 0;
                                 self.videoPlayerWidthConstraint.constant = [UIScreen mainScreen].bounds.size.height;
                                 self.videoPlayerHeightConstraint.constant = [UIScreen mainScreen].bounds.size.width;
                             }
                             else{
                                 
                                 self.videoPlayerYConstraint.constant = -128;
                                 NSLog(@"videPlayer height %lf,%lf",([UIScreen mainScreen].bounds.size.width * 3 ) / 4.0f,floor(([UIScreen mainScreen].bounds.size.width * 3) / 4.0f));
                                 self.videoPlayerHeightConstraint.constant = floor(([UIScreen mainScreen].bounds.size.width * 3 ) / 4.0f);
                                 self.videoPlayerWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width;
                             }
                             [self.videoView layoutIfNeeded];
                         }
                         self.videoView.transform =  CGAffineTransformMakeRotation( M_PI * self.angleRation / 2);
                     }
                     completion:^(BOOL finished) {
                     }];
    
    
    
    //NSInteger differValue = deviceOrientation - self.previousDeviceOrientation;
    //NSLog(@"previous %d, current %d, differVaue = %d,angleRation = %d",self.previousDeviceOrientation, deviceOrientation,differValue,_angleRation);
    self.previousDeviceOrientation = tOrientation;
}

#pragma mark - *** Override ***
- (BOOL)prefersStatusBarHidden
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft ||
        deviceOrientation == UIDeviceOrientationLandscapeRight) {
        return YES;
    }
    else{
        return NO;
    }
}

@end
