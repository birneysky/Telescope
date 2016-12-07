//
//  TextFrameParser.h
//  Telescope
//
//  Created by zhangguang on 16/12/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TETextLayoutModel.h"
#import "TEChatMessage.h"
#import "TETextAttibuteConfig.h"

@interface TETextFrameParser : NSObject

+ (TETextLayoutModel *)parseChatMessage:(TEChatMessage *)message;

+ (TETextLayoutModel *)parseChatMessage:(TEChatMessage *)message config:(TETextAttibuteConfig*)config;

@end
