//
//  TENetworkKit.h
//  Telescope
//
//  Created by zhangguang on 16/10/10.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEResponse.h"
#import "TEUser.h"
#import "TELiveShowInfo.h"

#define TENETWORKKIT [TENetworkKit defaultKit]


/**
 网络接口类，单例类，定义了与服务器交互的接口
 
 */

@interface TENetworkKit : NSObject

/**
  获取网络包实例

 @return 实例指针
 */

+ (instancetype)defaultKit;


/**
 登录

 @param aNum       用户名
 @param pwd        密码
 @param comletion 登录操作结束block
 @param errorblock      错误block
 */

- (void)loginWithAccountNum:(NSString*)aNum
                   password:(NSString*)pwd
                 completion:(void(^)(TEResponse<TEUser*>* response))comletion
                    onError:(void(^)())errorblock;



/**
 获取手机验证码

 @param num 手机号码
 */
- (void)fetchSMSVerificationCodeWithPhoneNumber:(NSString*)num;


/**
 获取视频直播列表

 @param comletion 列表回传完成 block
 */
- (void)fetchLiveShowListWithCompletion:(void(^)(TEResponse<NSArray<TELiveShowInfo*>*>* response))comletion
                                onError:(void(^)(NSError* error))err;


/**
 关注某个用户

 @param userID 用户id
 */
- (void)payAttentionToUser:(NSUInteger)userID
                completion:(void(^)())completion
                    onError:(void(^)(NSError* error))err;


/**
 取消关注某个用户

 @param userID 用户id
 */
- (void)cancelAttentionToUser:(NSUInteger)userID
                   completion:(void(^)())completion
                       onError:(void(^)(NSError* error))err;




/**
 获取粉丝列表

 @param from 列表开始偏移量
 @param to 结束偏移量
 @param completion 列表回传完成 block
 @param err 错误block
 */
- (void)fetchFansInfoWithFormOffset:(NSInteger)from
                           toOffset:(NSInteger)to
                         completion:(void(^)(TEResponse<NSArray<TEUser*>*>* response))completion
                            onError:(void(^)(NSError* error))err;

@end
