//
//  TEVideoPlayerViewController.m
//  Telescope
//
//  Created by zhangguang on 17/1/11.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import "TEVideoPlayerViewController.h"

#import "TEVideoPlayer.h"
#import "TEBroadcastLiveViewController.h"
#import "TEV2KitChatDemon.h"

@interface TEVideoPlayerViewController ()
@property (weak, nonatomic) IBOutlet TEVideoPlayer *videoPlayer;

@end

@implementation TEVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.videoPlayer startRtmpPlayWithUrl:self.url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if([segue.identifier isEqualToString:@"te_present_enter_liveshow"]){
//        TEBroadcastLiveViewController* blvc = segue.destinationViewController;
//        //blvc.backgroundImage = [self screenshot];
//        blvc.userID = [TEV2KitChatDemon defaultDemon].selfUser.userID;
//        blvc.communicateWithAnchor = [segue.identifier isEqualToString:@"te_present_enter_liveshow"] ? YES : NO;
//    }
//
//}

#pragma mark - *** Target Action ***
- (IBAction)joinShowBtnClicked:(id)sender {
    [self.videoPlayer stopRtmpPlay];
    NSLog(@"🍎🍎🍎🍎🍎%@,%@,%@",self.presentedViewController,self.presentationController,self.presentingViewController);
    UIViewController* presentingVC = self.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{
         [presentingVC performSegueWithIdentifier:@"push_enter_live" sender:sender];
    }];
    
}

- (IBAction)closeVideoBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.videoPlayer stopRtmpPlay];
    }];
}
@end
