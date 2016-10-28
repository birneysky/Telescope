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
 @param complation 登录操作结束block
 @param error      错误block
 */

- (void)loginWithAccountNum:(NSString*)aNum
                   password:(NSString*)pwd
                 completion:(void(^)(TEResponse<TEUser*>* response))complation
                    onError:(void(^)())error;




@end
