//
//  TEMessage+CoreDataProperties.h
//  
//
//  Created by zhangguang on 16/11/30.
//
//

#import "TEMessage.h"

@class TEChatSession;

NS_ASSUME_NONNULL_BEGIN

@interface TEMessage (CoreDataProperties)

+ (NSFetchRequest<TEMessage *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString* mID;
@property (nonatomic) int64_t senderID;
@property (nonatomic) int64_t receiverID;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *sendTime;
@property (nonatomic) int16_t type;
@property (nullable, nonatomic, copy) NSDate *recvTime;
@property (nonatomic, assign) int32_t sessionID;

@end

NS_ASSUME_NONNULL_END
