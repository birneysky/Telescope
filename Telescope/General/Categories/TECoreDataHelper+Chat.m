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
#import "TEMessage+CoreDataProperties.h"
#import "TEChatMessage.h"

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

-(void)excuteBlock:(void (^)())block
{
    __weak NSManagedObjectContext* context = [[TECoreDataHelper defaultHelper] backgroundContext];
    [context performBlock:^{
        if (block) {
            block();
        }
        
        if ([context hasChanges]) {
            NSError* error;
            [context save:&error];
        }
    }];
}

- (void)insertNewMessages:(NSArray<TEChatMessage*>*)chatMessages
                 senderID:(int64_t) sid
              chatSession:(TEChatSession*)session
               completion:(void (^)(NSArray<TEMessage*>* array))completion
{
    NSMutableArray<TEMessage*>* msgs = [[NSMutableArray alloc] initWithCapacity:chatMessages.count];
    NSManagedObjectContext* context = [[TECoreDataHelper defaultHelper] backgroundContext];
    [[[TECoreDataHelper defaultHelper] backgroundContext] performBlock:^{
        for (int i =0 ; i < chatMessages.count; i++) {
            TEChatMessage* chatMessage = chatMessages[i];
            //            chatMessage.senderIsMe = YES;
            //            chatMessage.time = [NSDate date];
            TEMessage* message =  [NSEntityDescription insertNewObjectForEntityForName:@"TEMessage" inManagedObjectContext:context];
            message.mID = chatMessage.messageID;
            message.senderID = sid;
            message.receiverID = session.remoteUsrID;
            message.content = [chatMessage xmlString];
            message.sendTime = 0;
            message.recvTime = 0;
            message.type = chatMessage.type;
            message.sessionID = session.sID;
            message.senderIsMe = YES;
            message.state = TEMsgTransStateReady;
            //message.chatMessage = chatMessage;
            session.totalNumOfMessage += 1;
            //[message layout];
            [msgs addObject:message];
        }
        session.overviewOfLastMessage = [chatMessages.lastObject overviewText];
        //[[TECoreDataHelper defaultHelper] saveBackgroundContext];
        if (completion) {
            completion([msgs copy]);
        }
        if ([context hasChanges]) {
            NSError* error;
            [context save:&error];
        }
    }];

}

- (void)resetStatusOfAllTransferingNotCompletedMessages
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TEMessage"];
    NSPredicate* predicat = [NSPredicate predicateWithFormat:@"state = %d || state = %d || state = %d ",
                             TEMsgTransStateReceiving,TEMsgTransStateSending,TEMsgTransStatePause];
    [fetchRequest setPredicate:predicat];
    
    NSError* error;
    NSArray<TEMessage*>* result = [self.backgroundContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        DDLogError(@"‼️‼️‼️‼️ executeFetchRequest error: %@",error);
    }
    
    [result enumerateObjectsUsingBlock:^(TEMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.state = TEMsgTransStateError;
    }];
    
    [self save];
}

- (void)deleteMessages:(NSArray<TEMessage*>*)msgs
{
    [self excuteBlock:^{
        [msgs enumerateObjectsUsingBlock:^(TEMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[TECoreDataHelper defaultHelper].backgroundContext deleteObject:obj];
        }];
    }];
}

- (void)updateWithBlock:(void (^)())block
{
    [self excuteBlock:block];
}

- (void)save
{
    __weak NSManagedObjectContext* weakContext = [TECoreDataHelper defaultHelper].backgroundContext;
    [weakContext performBlock:^{
        if ([weakContext hasChanges]) {
            NSError* error;
            [weakContext save:&error];
        }
    }];
}

- (void)saveWithBlock:(void (^)())block
{
    if (block) {
        [self excuteBlock:block];
    }
}

@end
