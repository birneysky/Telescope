//
//  TECacheUser+CoreDataProperties.m
//  
//
//  Created by zhangguang on 16/11/30.
//
//

#import "TECacheUser+CoreDataProperties.h"

@implementation TECacheUser (CoreDataProperties)

+ (NSFetchRequest<TECacheUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TECacheUser"];
}

@dynamic nickName;
@dynamic uid;

@end
