//
//  TEKeyChain.h
//  Telescope
//
//  Created by zhangguang on 16/12/16.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEKeyChain : NSObject

+ (void)saveUserInfo:(NSDictionary*)usrInfo;

+ (NSDictionary*)readUserInfo;

+ (void)deleteUserInfo;

@end
