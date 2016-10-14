//
//  TENetworkKit.m
//  Telescope
//
//  Created by zhangguang on 16/10/10.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TENetworkKit.h"
#import <UIKit/UIKit.h>
#import "TENetworkEngine.h"

static TENetworkKit* defaultKit;



@interface TENetworkKit ()

@property (nonatomic,strong) TENetworkEngine* networkEngine;

@end


@implementation TENetworkKit

+ (instancetype)defaultNetKit
{
    if (!defaultKit) {
        defaultKit = [[TENetworkKit alloc] init];
    }
    return defaultKit;
}

+ (instancetype) allocWithZone:(struct _NSZone *)zone
{
    if (!defaultKit) {
        defaultKit = [super allocWithZone:zone];
    }
    return defaultKit;
}

- (instancetype) copy{
    return defaultKit;
}


#pragma mark - *** Properties ***
- (TENetworkEngine*) networkEngine
{
    if (!_networkEngine) {
        _networkEngine = [[TENetworkEngine alloc] initWithHostName:@"123.57.20.30" port:9997];
    }
    return _networkEngine;
}


- (void) loginWithAccountNum:(NSString*)anum password:(NSString*)pwd
{
    
}



@end
