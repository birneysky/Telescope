//
//  TETestViewController.m
//  Telescope
//
//  Created by zhangguang on 16/11/10.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TETestViewController.h"

@interface TETestViewController ()
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testviewTrailingViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testViewHeightConstraint;

/**
 上一次设备的方向
 */
@property (nonatomic,assign) UIDeviceOrientation previousDeviceOrientation;

/**
 旋转的角度的倍数
 */
@property (nonatomic,assign)  NSInteger angleRation;

@end

@implementation TETestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.angleRation = 0;
    self.previousDeviceOrientation = UIDeviceOrientationPortrait;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

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
}



#pragma mark - **** Helper ****
- (void)rotateVideoViewFromOrientation:(UIDeviceOrientation) fOrientation ToOrientation:(UIDeviceOrientation) tOrientation{
    
//    if (tOrientation != UIDeviceOrientationPortrait) {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }
//    else{
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
    
    BOOL resizeFlag = NO;
    
    if((fOrientation == UIDeviceOrientationPortrait && tOrientation == UIDeviceOrientationLandscapeLeft) ||
       (fOrientation == UIDeviceOrientationLandscapeLeft && tOrientation == UIDeviceOrientationPortraitUpsideDown)||
       (fOrientation == UIDeviceOrientationPortraitUpsideDown && tOrientation == UIDeviceOrientationLandscapeRight) ||
       (fOrientation == UIDeviceOrientationLandscapeRight && tOrientation == UIDeviceOrientationPortrait)){
        self.angleRation ++;
        resizeFlag = YES;
    }
    
    if ((fOrientation == UIDeviceOrientationPortrait && tOrientation == UIDeviceOrientationLandscapeRight) ||
        (fOrientation == UIDeviceOrientationLandscapeRight && tOrientation == UIDeviceOrientationPortraitUpsideDown) ||
        (fOrientation == UIDeviceOrientationPortraitUpsideDown && tOrientation == UIDeviceOrientationLandscapeLeft) ||
        (fOrientation == UIDeviceOrientationLandscapeLeft && tOrientation == UIDeviceOrientationPortrait)) {
        self.angleRation --;
        resizeFlag = YES;
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
                         if (resizeFlag) {
                             //
                             if (tOrientation != UIDeviceOrientationPortrait) {
                                 self.testViewHeightConstraint.constant = 500;
                                 //self.testviewTrailingViewConstraint.constant = -100;
                             }
                             else{
                                 self.testViewHeightConstraint.constant = 267;
                             }
                             [self.testView layoutIfNeeded];
                             NSLog(@"layoutIfNeeded %@",NSStringFromCGRect(self.testView.frame));
                         }
                         self.testView.transform =  CGAffineTransformMakeRotation( M_PI * self.angleRation / 2);
                     }
                     completion:^(BOOL finished) {
                     }
     ];
    
    self.previousDeviceOrientation = tOrientation;
}

@end
