//
//  ViewController.m
//  Telescope
//
//  Created by Showers on 16/9/2.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "ViewController.h"
#import "TENetworkKit.h"

@interface ViewController ()


@end



@implementation ViewController

#pragma mark - *** Properties ****


#pragma makr - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];

    //[self.client connectToHost:@"123.57.20.30" onPort:9997 error:&error];

    self.view.backgroundColor = RGB(30, 30, 30);
    
    //[TENetworkKit defaultNetKit];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    while (true) {
//        [self loginBtnClicked:nil];
//        sleep(5);
//        [self disconnectBtnClicked:nil];
//    }
}

#pragma mark - *** Target Action ***

- (IBAction)loginBtnClicked:(id)sender {
    NSError* error;
    //[self.netEngine connectToHost:@"123.57.20.31" onPort:9997 error:&error];
    //[self.netEngine connectToHost:@"192.168.0.103" onPort:9997 error:&error];
    [[TENetworkKit defaultNetKit] loginWithAccountNum:@"" password:@""];
    if(error){
        NSLog(@"%@",error);
    }
}


- (IBAction)disconnectBtnClicked:(id)sender {
    //[self.netEngine disconnect];
}


@end
