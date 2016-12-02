//
//  TEChatSession+CoreDataProperties.h
//  
//
//  Created by zhangguang on 16/11/30.
//
//
#import "TEChatSession.h"

@class TEMessage;

NS_ASSUME_NONNULL_BEGIN

@interface TEChatSession (CoreDataProperties)

+ (NSFetchRequest<TEChatSession *> *)fetchRequest;

@property (nonatomic) int64_t groupID;
@property (nonatomic) int16_t groupType;
@property (nonatomic) int64_t senderID;
@property (nullable, nonatomic, copy) NSDate *timeToRecvLastMessage;
@property (nullable, nonatomic, copy) NSString *overviewOfLastMessage;
@property (nonatomic) int16_t lastMessageType;
@property (nullable, nonatomic, retain) NSSet<TEMessage *> *messages;

@end

@interface TEChatSession (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(TEMessage *)value;
- (void)removeMessagesObject:(TEMessage *)value;
- (void)addMessages:(NSSet<TEMessage *> *)values;
- (void)removeMessages:(NSSet<TEMessage *> *)values;

@end

NS_ASSUME_NONNULL_END
