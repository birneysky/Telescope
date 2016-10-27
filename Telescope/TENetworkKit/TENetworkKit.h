//
//  TENetworkKit.h
//  Telescope
//
//  Created by zhangguang on 16/10/10.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TENetworkKit : NSObject

+ (instancetype)defaultNetKit;


/**
 登录

 @param anum 用户名
 @param pwd  密码
 */

- (void) loginWithAccountNum:(NSString*)anum password:(NSString*)pwd;




@end
