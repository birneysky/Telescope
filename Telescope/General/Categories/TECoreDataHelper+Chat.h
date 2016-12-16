//
//  TECoreDataHelper+Chat.h
//  Telescope
//
//  Created by zhangguang on 16/12/16.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TECoreDataHelper.h"

@class TEChatSession;

@interface TECoreDataHelper (Chat)

- (TEChatSession*)fetchSessionWithSenderID:(long long)uid;

@end
