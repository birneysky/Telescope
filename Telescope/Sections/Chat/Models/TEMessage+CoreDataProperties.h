//
//  TEMessage+CoreDataProperties.h
//  
//
//  Created by zhangguang on 16/11/30.
//
//

#import "TEMessage.h"


typedef NS_ENUM(int16_t,TEMsgTransState){
    TEMsgTransStateReady = 0,
    TEMsgTransStateReceiving,
    TEMsgTransStateSending,
    TEMsgTransStatePause,
    TEMsgTransStateSucced,
    TEMsgTransStateError
};

@class TEChatSession;

NS_ASSUME_NONNULL_BEGIN

@interface TEMessage (CoreDataProperties)

+ (NSFetchRequest<TEMessage *> *)fetchRequest;


/**
 消息id
 */
@property (nullable, nonatomic, copy) NSString* mID;

/**
 发送者id
 */
@property (nonatomic) int64_t senderID;

/**
 接受者id
 */
@property (nonatomic) int64_t receiverID;

/**
 消息内容 xml 格式字符串
 */
@property (nullable, nonatomic, copy) NSString *content;

/**
 消息发送时间
 */
@property (nullable, nonatomic, copy) NSDate *sendTime;

/**
 消息类型
 */
@property (nonatomic) int16_t type;


/**
 消息收到时间
 */
@property (nullable, nonatomic, copy) NSDate *recvTime;

/**
 会话id
 */
@property (nonatomic, assign) int32_t sessionID;

/**
 消息的发送者是不是自己
 */
@property (nonatomic,assign) BOOL senderIsMe;

/**
 消息的传输状态
 */
@property (nonatomic,assign) TEMsgTransState state;


/**
 消息是否已读
 */
@property (nonatomic,assign) BOOL read;

@end

NS_ASSUME_NONNULL_END
