//
//  TECoreDataHelper+Chat.h
//  Telescope
//
//  Created by zhangguang on 16/12/16.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TECoreDataHelper.h"

typedef NS_ENUM(NSInteger,TEFileType){
    TypePicture = 1,
    TypeAudio
};

@class TEChatSession;
@class TEMediaFileLocation;

@interface TECoreDataHelper (Chat)

- (TEChatSession*)fetchSessionWithRemoteUsrID:(long long)uid;

- (TEChatSession*)insertNewSessionWithRemoteUserID:(long long)uid;

- (TEMediaFileLocation*)insertNewFileLocationWithFileID:(NSString*)fid session:(int32_t)sid type:(TEFileType)t;

@end
