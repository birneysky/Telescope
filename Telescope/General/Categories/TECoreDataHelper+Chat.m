//
//  TECoreDataHelper+Chat.m
//  Telescope
//
//  Created by zhangguang on 16/12/16.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TECoreDataHelper+Chat.h"
#import "TEChatSession+CoreDataProperties.h"
#import "TEMediaFileLocation+CoreDataProperties.h"

@implementation TECoreDataHelper (Chat)

- (TEChatSession*)fetchSessionWithRemoteUsrID:(long long)uid
{
    __weak NSManagedObjectContext* weakContext = self.backgroundContext;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TEChatSession"];
    NSPredicate* predicat = [NSPredicate predicateWithFormat:@"remoteUsrID == %lld",uid];
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
        NSAssert(result.count > 2, @"data bug");
    }
    return nil;
}

- (TEChatSession*)insertNewSessionWithRemoteUserID:(long long)uid
{
    NSManagedObjectContext* context = self.backgroundContext;
    NSInteger sessionCount = [context countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"TEChatSession"] error:nil];
    TEChatSession* session  = [NSEntityDescription insertNewObjectForEntityForName:@"TEChatSession" inManagedObjectContext:context];
    session.groupID = 0;
    session.groupType = 0;
    session.remoteUsrID = uid;
    session.timeToRecvLastMessage = [NSDate date];
    //session.overviewOfLastMessage = [NSString stringWithFormat:@"%@:%lu ---> self are you ok",sid,index];
    //session.lastMessageType = message.type;
    session.sID = (int32_t)sessionCount + 1;
    return session;
}

- (TEMediaFileLocation*)insertNewFileLocationWithFileID:(NSString*)fid session:(int32_t)sid type:(TEFileType)t
{
    NSManagedObjectContext* context = self.backgroundContext;
    TEMediaFileLocation* fileLocation = [NSEntityDescription insertNewObjectForEntityForName:@"TEMediaFileLocation" inManagedObjectContext:context];
    fileLocation.fileID = fid;
    fileLocation.sessionID = sid;
    fileLocation.saveTime = [NSDate date];
    fileLocation.fileType = t;
    return fileLocation;
}

@end
