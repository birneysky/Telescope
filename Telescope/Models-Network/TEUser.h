//
//  TEUser.h
//  Telescope
//
//  Created by zhangguang on 16/10/28.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用户类
 */
@interface TEUser : NSObject

/**
 用户id
 */
@property (nonatomic,assign) uint64_t userID;

/**
 用户密码 有必要在这里保存用户的密码嘛，用户的密码需要服务器告知吗，用户自己不知道？
 */
@property (nonatomic,copy) NSString* password;

/**
 密码或者验证码，到底是密码还是验证码呀？ 奇葩定义
 */
@property (nonatomic,copy) NSString*  passwordOrVerificationCode;
/**
 手机号码
 */
@property (nonatomic,copy) NSString* phoneNum;

/**
 直播秀场用户名
 */
@property (nonatomic,copy) NSString* showUserName;

/**
 直播秀场密码  有必要有这个嘛，很怀疑
 */
@property (nonatomic,copy) NSString* showPassword;

@end
