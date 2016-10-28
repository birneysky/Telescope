//
//  TENetworkKit.m
//  Telescope
//
//  Created by zhangguang on 16/10/10.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TENetworkKit.h"
#import "TENetworkEngine.h"
#import <ProtocolBuffers/ProtocolBuffers.h>

static TENetworkKit* defaultKit;



@interface TENetworkKit ()

@property (nonatomic,strong) TENetworkEngine* networkEngine;

@end


@implementation TENetworkKit

+ (instancetype)defaultKit
{
    if (!defaultKit) {
        defaultKit = [[TENetworkKit alloc] init];
        //[defaultKit networkEngine];
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
       // _networkEngine = [[TENetworkEngine alloc] initWithHostName:@"192.168.0.93" port:5123];
    }
    return _networkEngine;
}


- (void)loginWithAccountNum:(NSString*)aNum
                   password:(NSString*)pwd
                 completion:(void(^)(TEResponse<TEUser*>* response))complation
                    onError:(void(^)())error
{
    V2PPacket* loginPacket = [[V2PPacket alloc] init];
    loginPacket.packetType = V2PPacket_type_Iq;
    loginPacket.version = @"1.3.1";
    loginPacket.method = @"login";
    loginPacket.operateType = @"smscode";
    
    V2PData* data = [[V2PData alloc] init];
    V2PUser* user= [[V2PUser alloc] init];
//    user.phone = @"15811004492";
//    user.pwd2OrCode = @"111111";
    user.phone = aNum;
    user.pwd2OrCode = pwd;
    user.deviceId = @"12316546765164";
    [data.userArray addObject:user];
    loginPacket.data_p = data;
    
    TENetworkOperation* op = [self.networkEngine operationWithParams:loginPacket];

    
    [op setCompletionHandler:^(TENetworkOperation *operation) {
        V2PPacket* packet = [operation responseData];
        TEResponse<TEUser*>* respone = [TEResponse new];
        respone.isSuccess = packet.result.result;
        respone.errorInfo = packet.result.error;
        
        TEUser* teUser = [[TEUser alloc] init];
        V2PUser* v2User = packet.data_p.userArray.firstObject;
        teUser.userID = v2User.id_p;
        teUser.phoneNum = v2User.phone;
        teUser.password = v2User.pwd;
        teUser.passwordOrVerificationCode = v2User.pwd2OrCode;
        teUser.showUserName = v2User.v2UserName;
        teUser.showPassword = v2User.v2Pwd;
        respone.body = teUser;
        complation(respone);
        NSLog(@"login response %@",packet);
    } errorHandler:^(NSError *error) {
        
    }];
    
    
    [self.networkEngine enqueueOperation:op];
}



@end

