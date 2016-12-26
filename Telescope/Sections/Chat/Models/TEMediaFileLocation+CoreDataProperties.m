//
//  TEMediaFileLocation+CoreDataProperties.m
//  
//
//  Created by zhangguang on 16/12/26.
//
//

#import "TEMediaFileLocation+CoreDataProperties.h"

@implementation TEMediaFileLocation (CoreDataProperties)

+ (NSFetchRequest<TEMediaFileLocation *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TEMediaFileLocation"];
}

@dynamic fileID;
@dynamic saveTime;
@dynamic sessionID;
@dynamic fileType;
@dynamic fileExt;

@end
