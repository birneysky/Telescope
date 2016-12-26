//
//  TEApplicationDemon.h
//  Telescope
//
//  Created by zhangguang on 16/12/16.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <V2Kit/V2Kit.h>
#import "TEUser.h"



#define TENewMessageComming  @"TENewMessageComming"


@interface TEV2KitChatDemon : NSObject <ChatDelegate>

@property (nonatomic,strong) TEUser* selfUser;

@property (nonatomic,readonly) NSString* pictureStorePath;

@property (nonatomic,readonly) NSString* audioStorePath;

+ (instancetype)defaultDemon;


@end
