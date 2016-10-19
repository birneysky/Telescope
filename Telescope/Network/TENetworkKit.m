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
#import <ProtocolBuffers/ProtocolBuffers.h>

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
    V2PPacket* loginPacket = [[V2PPacket alloc] init];
    loginPacket.packetType = V2PPacket_type_Iq;
    loginPacket.version = @"1.3.1";
    loginPacket.method = @"login";
    loginPacket.operateType = @"smscode";
    
    V2PData* data = [[V2PData alloc] init];
    V2PUser* user= [[V2PUser alloc] init];
    //user.phone = @"15811004492";
    //user.pwd2OrCode = @"111111";
    //user.deviceId = @"12316546765164";
    [data.userArray addObject:user];
    //loginPacket.data_p = data;
    
    TENetworkOperation* op = [self.networkEngine operationWithParams:loginPacket];

    
    [op setCompletionHandler:^(TENetworkOperation *operation) {
        
    } errorHandler:^(NSError *error) {
        
    }];
    
    
    [self.networkEngine enqueueOperation:op];
}



@end
