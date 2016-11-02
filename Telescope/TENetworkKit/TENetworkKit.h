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
 @param error      错误block
 */

- (void)loginWithAccountNum:(NSString*)aNum
                   password:(NSString*)pwd
                 completion:(void(^)(TEResponse<TEUser*>* response))comletion
                    onError:(void(^)())error;



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

@end
