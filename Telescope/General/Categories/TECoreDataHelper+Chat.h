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
@class TEChatMessage;
@class TEMessage;

@interface TECoreDataHelper (Chat)


/**
 根据用户id查询聊天会话信息

 @param uid 用户id
 @return 会话对象实例
 */
- (TEChatSession*)fetchSessionWithRemoteUsrID:(long long)uid;


/**
 为某个用户插入一个新的聊天会话

 @param uid 用户id
 @return 会话对象实例
 */
- (TEChatSession*)insertNewSessionWithRemoteUserID:(long long)uid;


/**
 存储一条新的文件位置记录

 @param fid 文件id
 @param sid 所属会话id
 @param t 文件类型
 @return 存储记录实例
 */
- (TEMediaFileLocation*)insertNewFileLocationWithFileID:(NSString*)fid session:(int32_t)sid type:(TEFileType)t;


/**
 异步存储数据库

 @param chatMessages 消息数据
 @param sid 发送者id
 @param session 会话对象
 @param completion 操作完成块
 */
- (void)insertNewMessages:(NSArray<TEChatMessage*>*)chatMessages
                 senderID:(int64_t) sid
              chatSession:(TEChatSession*)session
               completion:(void (^)(NSArray<TEMessage*>* array))completion;



/**
 重置所有未传输完成的消息的状态，将这些消息的状态都置为传输失败
 */
- (void)resetStatusOfAllTransferingNotCompletedMessages;

/**
 删除聊条消息记录

 @param msgs 消息对象实例数组
 */
- (void)deleteMessages:(NSArray<TEMessage*>*)msgs;


/**
 异步更新coredata数据

 @param block 更新逻辑block
 */
- (void)updateWithBlock:(void (^)())block;


/**
 异步存储
 */
- (void)save;


/**
 异步存储
 
 存储之前可以做某些操作，这些操作可以放入block中

 @param block 存储之前需要执行的block
 */
- (void)saveWithBlock:(void (^)())block;



@end
