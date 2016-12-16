//
//  TEVideoChatViewController.m
//  Telescope
//
//  Created by zhangguang on 16/12/15.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEVideoChatViewController.h"
#import <V2Kit/V2Kit.h>

@interface TEVideoChatViewController ()<VideoChatDelegate>
@property (weak, nonatomic) IBOutlet UIView *videoView;

@end

@implementation TEVideoChatViewController

- (void)dealloc
{
    [[V2Kit defaultKit] closeCamera];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [V2Kit defaultKit].videoDelegate = self;
    [[V2Kit defaultKit] openCameraWithRenderView:self.videoView useFrontCamera:YES];
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

#pragma mark - *** UIOrientation ***
- (BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - *** Target Action ***
- (IBAction)huangupBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)switchCameraBtnClicked:(id)sender {
    [[V2Kit defaultKit] switchCameraWithRenderView:self.videoView];
}


#pragma mark - *** VideoChatDelegate ***

- (void) onVideoUserDevices:(long long)nUserID devices:(NSString*)szDevicesXml
{
    
}


- (void) onVideoChatInvite:(NSString*)sessionID userID:(long long)uid deviceID:(NSString*)did
{
    
}

- (void) onVideoChatAccepted:(NSString*)sessionID userID:(long long)uid deviceID:(NSString*)did
{
    
}

- (void) onVideoChatRefused:(NSString*)sessionID userID:(long long)uid deviceID:(NSString*)did
{
    
}

- (void) onVideoChating:(NSString*)sessionID userID:(long long)uid deviceID:(NSString*)did
{
    
}

- (void) onVideoChatClosed:(NSString*)sessionID userID:(long long)uid deviceID:(NSString*)did
{
    
}

- (void) onVideoSizeReport:(CGSize)size
{
    
}

@end
