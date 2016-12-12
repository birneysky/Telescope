//
//  TEChatSession+CoreDataProperties.m
//  
//
//  Created by zhangguang on 16/11/30.
//
//

#import "TEChatSession+CoreDataProperties.h"

@implementation TEChatSession (CoreDataProperties)

+ (NSFetchRequest<TEChatSession *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TEChatSession"];
}

@dynamic groupID;
@dynamic groupType;
@dynamic senderID;
@dynamic timeToRecvLastMessage;
@dynamic overviewOfLastMessage;
@dynamic lastMessageType;
@dynamic sID;
@dynamic totalNumOfMessage;

@end
