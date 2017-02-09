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


/**
 图片文件存储路径
 */
@property (nonatomic,readonly) NSString* pictureStorePath;


/**
  音频文件存储路径
 */
@property (nonatomic,readonly) NSString* audioStorePath;


/**
 当前正在活动的会话id，会话关闭时，请将改属性置为0
 */
@property (nonatomic,assign) int32_t activeSessionID;


+ (instancetype)defaultDemon;


@end
