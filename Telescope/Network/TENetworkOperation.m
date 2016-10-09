//
//  TENetworkOperation.m
//  Telescope
//
//  Created by zhangguang on 16/10/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TENetworkOperation.h"

typedef NS_ENUM(NSInteger, TENetworkOperationState) {
    TENetworkOperationStateReady = 1,
    TENetworkOperationStateExecuting = 2,
    TENetworkOperationStateFinished = 3
};


@interface TENetworkOperation ()

@property (nonatomic,copy) NSData* toBePostedData;

@property (nonatomic,assign) TENetworkOperationState state;


@end

@implementation TENetworkOperation


- (void)main{
    NSLog(@"main");
}


@end
