//
//  ViewController.m
//  Telescope
//
//  Created by zhangguang on 16/9/2.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "ViewController.h"

#import "TENetworkEngine.h"


@interface ViewController ()

@property (nonatomic,strong) TENetworkEngine* netEngine;

@end



@implementation ViewController

#pragma mark - *** Properties ****

- (TENetworkEngine*) netEngine
{
    if (!_netEngine) {
        _netEngine = [[TENetworkEngine alloc] init];
    }
    return _netEngine;
}

#pragma makr - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];

    //[self.client connectToHost:@"123.57.20.30" onPort:9997 error:&error];

    self.view.backgroundColor = RGB(30, 30, 30);
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
    [self.netEngine connectToHost:@"123.57.20.30" onPort:9997 error:&error];
    if(error){
        NSLog(@"%@",error);
    }
}


- (IBAction)disconnectBtnClicked:(id)sender {
    [self.netEngine disconnect];
}


@end
