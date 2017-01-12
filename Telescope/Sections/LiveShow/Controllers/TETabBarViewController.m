//
//  TETabBarViewController.m
//  Telescope
//
//  Created by zhangguang on 17/1/11.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import "TETabBarViewController.h"
#import "TEBroadcastLiveViewController.h"
#import "TEV2KitChatDemon.h"

@interface TETabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation TETabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     if ([segue.identifier isEqualToString:@"push_broadcast_live"]||
          [segue.identifier isEqualToString:@"push_enter_live"]) {

         TEBroadcastLiveViewController* blvc = segue.destinationViewController;
         blvc.backgroundImage = [self screenshot];
         blvc.userID = [TEV2KitChatDemon defaultDemon].selfUser.userID;
         blvc.communicateWithAnchor = [segue.identifier isEqualToString:@"push_enter_live"] ? YES : NO;
     }
 }
#pragma mark - *** Helper ***


- (UIImage *)screenshot{
    // UIView* view = [self.view snapshotViewAfterScreenUpdates:YES];
    //UIView* view = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    UIView* view = self.view;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    } else {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - *** UITabBarControllerDelegate ***
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    NSLog(@"🍎🍎🍎🍎🍎🍎🍎🍎%ld",index);
    //self.selectedIndex = 0;
    if (3 != index) {
        return YES;
    }
    [self performSegueWithIdentifier:@"push_broadcast_live" sender:nil];
    return NO;
}

@end
