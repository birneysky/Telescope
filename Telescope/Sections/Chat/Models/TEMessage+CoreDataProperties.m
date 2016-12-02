//
//  TEMessage+CoreDataProperties.m
//  
//
//  Created by zhangguang on 16/11/30.
//
//

#import "TEMessage+CoreDataProperties.h"

@implementation TEMessage (CoreDataProperties)

+ (NSFetchRequest<TEMessage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TEMessage"];
}

@dynamic mid;
@dynamic senderID;
@dynamic receiverID;
@dynamic content;
@dynamic sendTime;
@dynamic type;
@dynamic recvTime;
@dynamic session;

@end
