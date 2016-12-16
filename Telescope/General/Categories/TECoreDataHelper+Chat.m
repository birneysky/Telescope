//
//  TECoreDataHelper+Chat.m
//  Telescope
//
//  Created by zhangguang on 16/12/16.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TECoreDataHelper+Chat.h"

@implementation TECoreDataHelper (Chat)

- (TEChatSession*)fetchSessionWithSenderID:(long long)uid
{
    __weak NSManagedObjectContext* weakContext = self.backgroundContext;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TEChatSession"];
    NSPredicate* predicat = [NSPredicate predicateWithFormat:@"senderID == %lld",uid];
    [fetchRequest setPredicate:predicat];
    NSError* error;
    NSArray* result = [weakContext executeFetchRequest:fetchRequest error:&error];
    if (result.count <= 0) {
        return nil;
    }
    else if(result.count == 1){
        return result.firstObject;
    }
    else{
        NSAssert(result.count > 2, @"da bug");
    }
    return nil;
}

@end
