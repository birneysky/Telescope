//
//  TEApplicationDemon.m
//  Telescope
//
//  Created by zhangguang on 16/12/16.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEV2KitChatDemon.h"
#import "TECoreDataHelper.h"
#import "TEChatSession+CoreDataProperties.h"
#import "TEMessage+CoreDataProperties.h"
#import "TEChatMessage.h"
#import "TEChatXMLReader.h"

static TEV2KitChatDemon* _demon = nil;

@interface TEV2KitChatDemon ()


@end

@implementation TEV2KitChatDemon
{
    NSString* _pictureStorePath;
    NSString* _audioStorePath;
}

+ (instancetype)defaultDemon
{
    if (!_demon) {
        _demon = [[TEV2KitChatDemon alloc] init];
    }
    return _demon;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!_demon) {
        _demon = [super allocWithZone:zone];
    }
    return _demon;
}


- (instancetype)copy
{
    return _demon;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return _demon;
}

- (NSString*)pictureStorePath
{
    if (!_pictureStorePath) {
        NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* storeDirectoryName = [NSString stringWithFormat:@"Stores-%lld",self.selfUser.userID];
        
        _pictureStorePath = [[documentPath stringByAppendingPathComponent:storeDirectoryName] stringByAppendingPathComponent:@"TEImages"];
    }
    return _pictureStorePath;
}


- (NSString*)audioStorePath
{
    if (!_pictureStorePath) {
        NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* storeDirectoryName = [NSString stringWithFormat:@"Stores-%lld",self.selfUser.userID];
        
        _pictureStorePath = [[documentPath stringByAppendingPathComponent:storeDirectoryName] stringByAppendingPathComponent:@"TEAudios"];
    }
    return _pictureStorePath;
}

#pragma mark - *** ChatDelegate ***

- (void)didReceiveChatMessage:(NSString*)xmlText  fromUserID:(long long)uid inGroup:(long long)gid messageID:(NSString*)mid sendTime:(NSDate*)date
{
    __weak NSManagedObjectContext* weakContext = [TECoreDataHelper defaultHelper].backgroundContext;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TEChatSession"];
    NSPredicate* predicat = [NSPredicate predicateWithFormat:@"remoteUsrID == %lld",uid];
    [fetchRequest setPredicate:predicat];
    NSError* error;
    NSArray* sessionArray = [weakContext executeFetchRequest:fetchRequest error:&error];
    
    TEChatMessage* chatMsgModel =  [TEChatXMLReader messageForXmlString:xmlText error:nil];
    chatMsgModel.senderIsMe = NO;
    chatMsgModel.time = date;
    
    [weakContext performBlock:^{

        NSDate* recvDate =  [NSDate date];
        TEMessage* message = [NSEntityDescription insertNewObjectForEntityForName:@"TEMessage" inManagedObjectContext:weakContext];
        message.mID = mid;
        message.senderID = uid;
        message.receiverID = self.selfUser.userID;
        message.content = xmlText;
        message.sendTime = date;
        message.type = MediaFileTypeText;
        message.recvTime = recvDate;
        message.chatMessage = chatMsgModel;
        
        TEChatSession* session = nil;
        if (sessionArray.count == 0){
            session  = [NSEntityDescription insertNewObjectForEntityForName:@"TEChatSession" inManagedObjectContext:weakContext];
            session.groupID = 0;
            session.groupType = 0;
            session.remoteUsrID = uid;
            session.timeToRecvLastMessage = recvDate;
            session.overviewOfLastMessage = @"Text";
            session.lastMessageType = message.type;
            session.sID = (int32_t)uid;

        }
        else if(sessionArray.count == 1){
            session = sessionArray.firstObject;
            session.timeToRecvLastMessage = [NSDate date];
            session.lastMessageType = message.type;
        }
        else{
            NSAssert(sessionArray.count > 1, @"两个相同的会话出现");
        }
        
        message.sessionID = session.sID;
        session.totalNumOfMessage += 1;
        [message layout];
        session.overviewOfLastMessage = [message.chatMessage overviewText];
        
        
        if ([weakContext hasChanges]) {
            NSError* error;
            [weakContext save:&error];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TENewMessageComming object:nil];
    }];
    
    if (chatMsgModel.type == TEChatMessageTypeRichText) {
        [chatMsgModel.msgItemList enumerateObjectsUsingBlock:^(TEMsgSubItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == Image) {
                TEMsgImageSubItem* imageItem = (TEMsgImageSubItem*)obj;
               
            }
        }];
    }

    
}


- (void)didReceiveMediaFile:(NSString*)fileName type:(MediaFileType)type fromUserID:(long long)uid inGroup:(long long)gid messageID:(NSString*)mid sendTime:(NSDate*)date
{
    
}


- (void)didReceiveResponseOfSendingTextMessage:(NSString*)messageID responseCode:(NSInteger)code fromUserID:(long long)uid inGroup:(long long)gid
{
    __weak NSManagedObjectContext* weakContext = [TECoreDataHelper defaultHelper].backgroundContext;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TEMessage"];
    NSPredicate* predicat = [NSPredicate predicateWithFormat:@"mID == %@",messageID];
    [fetchRequest setPredicate:predicat];
    NSError* error;
    NSArray<TEMessage*>* messageArray = [weakContext executeFetchRequest:fetchRequest error:&error];
    NSAssert(messageArray.count == 1, @"有多个条件满足条件");
    
    __weak TEMessage* message = messageArray.firstObject;
    [weakContext performBlock:^{
        message.state = code == 0 ? TEMsgTransStateSucced : TEMsgTransStateError;
        if ([weakContext hasChanges]) {
            NSError* error;
            [weakContext save:&error];
        }
    }];
}


- (void)didReceiveResponseOfSendingMediaFile:(NSString*)fileID responseCode:(NSInteger)code  type:(MediaFileType)type  fromUserID:(long long)uid inGroup:(long long)gid
{
    
}

- (void)didReceiveMonitorResponse:(NSInteger)code fileID:(NSString*)fid type:(MediaFileType)type
{
    
}

@end
