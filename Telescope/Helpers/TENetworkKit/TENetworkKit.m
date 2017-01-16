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
                    onError:(void(^)())errorblock
{
    NSString* uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];;
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
    user.deviceId = uuid;
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
        DDLogInfo(@"📩📩📩📩 login response len %ld %@",(long)[packet.data length],packet);
    } errorHandler:^(NSError *error) {
        errorblock();
    }];
    
    
    [self.networkEngine enqueueOperation:op];
}


- (void)fetchSMSVerificationCodeWithPhoneNumber:(NSString*)num
{
    V2PPacket* smsPacket = [[V2PPacket alloc] init];
    smsPacket.packetType = V2PPacket_type_Iq;
    smsPacket.version = @"1.3.1";
    smsPacket.method = @"login";
    smsPacket.operateType = @"getSMScode";
    
    V2PData* data = [[V2PData alloc] init];
    data.normal = num;
    smsPacket.data_p = data;
    
    TENetworkOperation* op = [self.networkEngine operationWithParams:smsPacket];
    [op setCompletionHandler:^(TENetworkOperation *operation) {
        V2PPacket* packet = [operation responseData];
        DDLogInfo(@"📩📩📩📩 sms code Response %@",packet);
    } errorHandler:^(NSError *error) {
        
    }];
    
    [self.networkEngine enqueueOperation:op];
}

- (void)fetchLiveShowListWithCompletion:(void(^)(TEResponse<NSArray<TELiveShowInfo*>*>* response))comletion
                                onError:(void(^)(NSError* error))err
{
    V2PPacket* liveShowPacket = [[V2PPacket alloc] init];
    liveShowPacket.packetType = V2PPacket_type_Iq;
    liveShowPacket.version = @"1.3.1";
    liveShowPacket.method = @"queryVideoList";
    liveShowPacket.operateType = @"map";
    
    V2PData* data = [[V2PData alloc] init];
    data.from = 1;
    data.to = 20;

    V2PPosition* postion = [[V2PPosition alloc] init];
    postion.latitude = 34.770904;
    postion.longitude = 113.612288;
    postion.radius = 500000000;
    [data.positionArray addObject:postion];
    
    liveShowPacket.data_p = data;
    
    TENetworkOperation* op = [self.networkEngine operationWithParams:liveShowPacket];
    [op setCompletionHandler:^(TENetworkOperation *operation) {
        TEResponse<NSArray<TELiveShowInfo*>*>* respone = [TEResponse new];
        V2PPacket* packet  = [operation responseData];
        DDLogInfo(@"📩📩📩📩 liveShowList response %@",packet);
        NSMutableArray<TELiveShowInfo*>* liveArray = [[NSMutableArray alloc] init];
        [packet.data_p.videoArray enumerateObjectsUsingBlock:^(V2PVideo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TELiveShowInfo* info = [[TELiveShowInfo alloc] init];
            info.liveId = obj.id_p;
            info.coordinate = CLLocationCoordinate2DMake(obj.position.latitude, obj.position.longitude);
            info.totalNumberOfPeopleWatchingLive = obj.sum;
            [liveArray addObject:info];
        }];
        respone.body = liveArray;
        comletion(respone);
    } errorHandler:^(NSError *error) {
        err(error);
    }];
    
    [self.networkEngine enqueueOperation:op];
}


- (void)payAttentionToUser:(NSUInteger)userID
                completion:(void(^)())completion
                    onError:(void(^)(NSError* error))err
{
    V2PPacket* focusPacket = [[V2PPacket alloc] init];
    focusPacket.packetType = V2PPacket_type_Iq;
    focusPacket.version = @"1.3.1";
    focusPacket.method = @"followUser";
    focusPacket.operateType = @"add";
    
    V2PData* data = [[V2PData alloc] init];
    V2PUser* user= [[V2PUser alloc] init];
    user.id_p = (int32_t)userID;
    [data.userArray addObject:user];
    
    focusPacket.data_p = data;
    
    
    TENetworkOperation* op = [self.networkEngine operationWithParams:focusPacket];
    [op setCompletionHandler:^(TENetworkOperation *operation) {
        //TEResponse<NSArray<TELiveShowInfo*>*>* respone = [TEResponse new];
        V2PPacket* packet  = [operation responseData];
        DDLogInfo(@"📩📩📩📩 payAttentionToSomeOne response %@",packet);
        completion();
    } errorHandler:^(NSError *error) {
        err(error);
    }];
    
    [self.networkEngine enqueueOperation:op];
    
    
}



- (void)cancelAttentionToUser:(NSUInteger)userID
                   completion:(void(^)())completion
                       onError:(void(^)(NSError* error))err
{
    
}



- (void)fetchFansInfoWithFormOffset:(NSInteger)from
                           toOffset:(NSInteger)to
                         completion:(void(^)(TEResponse<NSArray<TEUser*>*>* response))completion
                            onError:(void(^)(NSError* error))err
{
    V2PPacket* fansPacket = [[V2PPacket alloc] init];
    fansPacket.packetType = V2PPacket_type_Iq;
    fansPacket.version = @"1.3.1";
    fansPacket.method = @"getFansList";
    fansPacket.operateType = @"add";
    
    V2PData* data = [[V2PData alloc] init];
    data.from = (int32_t)from;
    data.to = (int32_t)to;
    
    fansPacket.data_p = data;
    
    TENetworkOperation* op = [self.networkEngine operationWithParams:fansPacket];
    [op setCompletionHandler:^(TENetworkOperation *operation) {
        TEResponse<NSArray<TEUser*>*>* respone = [TEResponse new];
        V2PPacket* packet  = [operation responseData];
        respone.isSuccess = packet.result.result;
        respone.errorInfo = packet.result.error;
        DDLogInfo(@"📩📩📩📩 fetchFans response %@",packet);
        NSMutableArray<TEUser*>* userArray = [[NSMutableArray alloc] init];
        [packet.data_p.userArray enumerateObjectsUsingBlock:^(V2PUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TEUser* teUser = [[TEUser alloc] init];
            teUser.userID = obj.id_p;
            teUser.phoneNum = obj.phone;
            [userArray addObject:teUser];
        }];
        respone.body = [userArray copy];
        completion(respone);
    } errorHandler:^(NSError *error) {
        err(error);
    }];
    
    [self.networkEngine enqueueOperation:op];
}


- (void)publishShowInfo:(TELiveShowInfo*)info
             completion:(void(^)())completion
                onError:(void(^)(NSError* error))err
{
    V2PPacket* showInfoPacket = [[V2PPacket alloc] init];
    showInfoPacket.packetType = V2PPacket_type_Iq;
    showInfoPacket.version = @"1.3.1";
    showInfoPacket.method = @"publicVideo";
    
    V2PPosition* position = [[V2PPosition alloc] init];
    position.longitude = info.coordinate.longitude;
    position.latitude = info.coordinate.latitude;
    
    
    V2PVideo* videoInfo = [[V2PVideo alloc] init];
    videoInfo.videoNum = [NSString stringWithFormat:@"%ld",info.liveId];
    videoInfo.position = position;
    
    
    V2PData* data = [[V2PData alloc] init];
    [data.videoArray addObject:videoInfo];
    
    showInfoPacket.data_p = data;
    
    TENetworkOperation* op = [self.networkEngine operationWithParams:showInfoPacket];
    [op setCompletionHandler:^(TENetworkOperation *operation) {
        TEResponse<NSArray<TEUser*>*>* respone = [TEResponse new];
        V2PPacket* packet  = [operation responseData];
        respone.isSuccess = packet.result.result;
        respone.errorInfo = packet.result.error;
        DDLogInfo(@"📩📩📩📩 fetchFans response %@",packet);
        completion();
    } errorHandler:^(NSError *error) {
        err(error);
    }];
    
    [self.networkEngine enqueueOperation:op];
}


- (void)leaveShowThatUserId:(NSInteger)uid
                    videoId:(NSInteger)vid
                 completion:(void(^)())completion
                    onError:(void(^)(NSError* error))err
{
    V2PPacket* leavePacket = [[V2PPacket alloc] init];
    leavePacket.packetType = V2PPacket_type_Iq;
    leavePacket.version = @"1.3.1";
    leavePacket.method = @"watchVideo";
    leavePacket.operateType = @"leave";
    leavePacket.from = [NSString stringWithFormat:@"%ld",(long)uid];
    
    V2PVideo* videoInfo = [[V2PVideo alloc] init];
    videoInfo.id_p = (int32_t)vid;
    videoInfo.videoPwd = @"0";
    
    V2PData* data = [[V2PData alloc] init];
    [data.videoArray addObject:videoInfo];
    
    leavePacket.data_p = data;
    
    
    TENetworkOperation* op = [self.networkEngine operationWithParams:leavePacket];
    [op setCompletionHandler:^(TENetworkOperation *operation) {
        V2PPacket* packet  = [operation responseData];
//        respone.isSuccess = packet.result.result;
//        respone.errorInfo = packet.result.error;
        DDLogInfo(@"📩📩📩📩 fetchFans response %@",packet);
        completion();
    } errorHandler:^(NSError *error) {
        err(error);
    }];
    
    
     [self.networkEngine enqueueOperation:op];
}



@end

