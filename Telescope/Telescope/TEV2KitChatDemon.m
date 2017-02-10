//
//  TEApplicationDemon.m
//  Telescope
//
//  Created by zhangguang on 16/12/16.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEV2KitChatDemon.h"
#import "TECoreDataHelper+Chat.h"
#import "TEChatSession+CoreDataProperties.h"
#import "TEMessage+CoreDataProperties.h"
#import "TEChatMessage.h"
#import "TEChatXMLReader.h"
#import "UIImage+Utils.h"

static TEV2KitChatDemon* _demon = nil;

@interface TEV2KitChatDemon ()

@property (nonatomic,strong) NSMutableDictionary<NSString*,TEMessage*>* processingMessage;

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
    if (!_audioStorePath) {
        NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* storeDirectoryName = [NSString stringWithFormat:@"Stores-%lld",self.selfUser.userID];
        
        _audioStorePath = [[documentPath stringByAppendingPathComponent:storeDirectoryName] stringByAppendingPathComponent:@"TEAudios"];
    }
    return _audioStorePath;
}


-(NSMutableDictionary<NSString*,TEMessage*>*)processingMessage
{
    if (!_processingMessage) {
        _processingMessage = [[NSMutableDictionary alloc] init];
    }
    return _processingMessage;
}


#pragma mark - *** ChatDelegate ***

- (void)didReceiveChatMessage:(NSString*)xmlText  fromUserID:(long long)uid inGroup:(long long)gid messageID:(NSString*)mid sendTime:(NSDate*)date
{
    DDLogInfo(@"📩📩📩📩 didReceiveChatMessage  xmlText =  %@",xmlText);
    __weak NSManagedObjectContext* weakContext = [TECoreDataHelper defaultHelper].backgroundContext;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TEChatSession"];
    NSPredicate* predicat = [NSPredicate predicateWithFormat:@"remoteUsrID == %lld",uid];
    [fetchRequest setPredicate:predicat];
    NSError* error;
    NSArray* sessionArray = [weakContext executeFetchRequest:fetchRequest error:&error];
    
    TEChatMessage* chatMsgModel =  [TEChatXMLReader messageForXmlString:xmlText error:nil];
    chatMsgModel.senderIsMe = NO;
    chatMsgModel.time = [NSDate date];
    

    [weakContext performBlock:^{
        TEMessage* message = [NSEntityDescription insertNewObjectForEntityForName:@"TEMessage" inManagedObjectContext:weakContext];
        if(TEChatMessageTypeImage == chatMsgModel.type ||
           TEChatMessageTypeAudio == chatMsgModel.type ){
            TEMsgImageSubItem* mediaItem = (TEMsgImageSubItem*)chatMsgModel.msgItemList.firstObject;
            [self.processingMessage setObject:message forKey:mediaItem.fileName];
            message.state = TEMsgTransStateReceiving;
            MediaFileType type = mediaItem.type == TEChatMessageTypeImage ? MediaFileTypePicture : MediaFileTypeAudio;
            [[V2Kit defaultKit] monitRecvMediaFile:mediaItem.fileName
                                              type:type];
        }
        else{
            message.state = TEMsgTransStateSucced;
        }
        
        
        message.mID = mid;
        message.senderID = uid;
        message.receiverID = self.selfUser.userID;
        message.content = xmlText;
        message.sendTime = chatMsgModel.time;
        message.type = chatMsgModel.type;
        message.recvTime = chatMsgModel.time;
        message.chatMessage = chatMsgModel;
        
        TEChatSession* session = nil;
        if (sessionArray.count == 0){
            session  = [NSEntityDescription insertNewObjectForEntityForName:@"TEChatSession" inManagedObjectContext:weakContext];
            session.groupID = 0;
            session.groupType = 0;
            session.remoteUsrID = uid;
            session.timeToRecvLastMessage = chatMsgModel.time;
            session.overviewOfLastMessage = @"Text";
            session.lastMessageType = message.type;
            session.sID = (int32_t)uid;

        }
        else if(sessionArray.count == 1){
            session = sessionArray.firstObject;
            session.timeToRecvLastMessage = chatMsgModel.time;;
            session.lastMessageType = message.type;
        }
        else{
            NSAssert(sessionArray.count > 1, @"两个相同的会话出现");
        }
        
        message.sessionID = session.sID;
        session.totalNumOfMessage += 1;
        
    
        if (self.activeSessionID != session.sID) {
            session.totalNumberOfUnreadMessage += 1;
        }
        else if(TEChatMessageTypeAudio != message.type){
            message.read = YES;
        }
        
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
                //TEMsgImageSubItem* imageItem = (TEMsgImageSubItem*)obj;
               
            }
        }];
    }

    
}


- (void)didReceiveMediaFile:(NSString*)fileName type:(MediaFileType)type fromUserID:(long long)uid inGroup:(long long)gid fileID:(NSString*)fid sendTime:(NSDate*)date
{
    //__weak NSManagedObjectContext* weakContext = [TECoreDataHelper defaultHelper].backgroundContext;
    NSString* typeName = nil; //MediaFileTypePicture == type ? "Picture" : "Audio"
    switch (type) {
        case MediaFileTypeText:
            typeName = @"TextFile";
            break;
        case MediaFileTypeAudio:
            typeName = @"Audio";
            break;
        case MediaFileTypePicture:
            typeName = @"Picture";
            break;
    }
    DDLogInfo(@"📩📩📩📩 didReceiveMediaFile  xmlText =  %@ fileId = %@",typeName, fid);
    
    TEMessage* message = self.processingMessage[fid];
    [self.processingMessage removeObjectForKey:fid];
    /// 生成缩略图
    if( MediaFileTypePicture == type){
        TEMsgImageSubItem* imageItem = (TEMsgImageSubItem*)message.chatMessage.msgItemList.firstObject;
        NSString* imagePath = [imageItem.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",imageItem.fileName,imageItem.fileExt]];
        UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
        NSString* thumbnailName =  [NSString stringWithFormat:@"%@_%@%@",imageItem.fileName,@"thumbnail",imageItem.fileExt];
        [image produceThumbnailInPath:imageItem.path minSize:CGSizeMake(40, 40) maxSize:CGSizeMake(200, 200) fileName:thumbnailName];
    }
    
    if(MediaFileTypeAudio == type){
        
    }
    
    
    ///修改消息传输状态并存储至数据库
    [[TECoreDataHelper defaultHelper] saveWithBlock:^{
        message.state = TEMsgTransStateSucced;
        [message reLayout];
    }];
}


- (void)didReceiveResponseOfSendingTextMessage:(NSString*)messageID responseCode:(NSInteger)code fromUserID:(long long)uid inGroup:(long long)gid
{
    
     DDLogInfo(@"📩📩📩📩 didReceiveResponseOfSendingTextMessage  messageID =  %@ ",messageID);
    
    __weak NSManagedObjectContext* weakContext = [TECoreDataHelper defaultHelper].backgroundContext;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TEMessage"];
    NSPredicate* predicat = [NSPredicate predicateWithFormat:@"mID == %@",messageID];
    [fetchRequest setPredicate:predicat];
    NSError* error;
    NSArray<TEMessage*>* messageArray = [weakContext executeFetchRequest:fetchRequest error:&error];
    NSAssert(messageArray.count == 1, @"有多个条件满足条件");
    
    __weak TEMessage* message = messageArray.firstObject;
    
    [weakContext performBlock:^{
        if(message.type == TEChatMessageTypeText ||
           message.type == TEChatMessageTypeRichText){
            message.state = code == 0 ? TEMsgTransStateSucced : TEMsgTransStateError;
        }
        else if(message.type == TEChatMessageTypeImage){
            TEMsgImageSubItem* imageItem = (TEMsgImageSubItem*)message.chatMessage.msgItemList.firstObject;
            [self.processingMessage setObject:message forKey:imageItem.fileName];
        }
        else if (message.type == TEChatMessageTypeAudio){
            TEMSgAudioSubItem* audioItem = (TEMSgAudioSubItem*)message.chatMessage.msgItemList.firstObject;
            [self.processingMessage setObject:message forKey:audioItem.fileName];
        }
        
        if ([weakContext hasChanges]) {
            NSError* error;
            [weakContext save:&error];
        }
    }];
}


- (void)didReceiveResponseOfSendingMediaFile:(NSString*)fileID responseCode:(NSInteger)code  type:(MediaFileType)type  fromUserID:(long long)uid inGroup:(long long)gid
{
    DDLogInfo(@"📩📩📩📩 didReceiveResponseOfSendingMediaFile  fileID =  %@ ",fileID);
     ///修改传输状态并存储至数据库
    TEMessage* message = self.processingMessage[fileID];
    if(message) [self.processingMessage removeObjectForKey:fileID];
    message.state = 0 == code ? TEMsgTransStateSucced : TEMsgTransStateError;
    [[TECoreDataHelper defaultHelper] save];
    
}

- (void)didReceiveMonitorResponse:(NSInteger)code fileID:(NSString*)fid type:(MediaFileType)type
{
    ///修改传输状态并存储至数据库
    TEMessage* message = self.processingMessage[fid];
    if(message) [self.processingMessage removeObjectForKey:fid];
    message.state = 0 == code ? TEMsgTransStateSucced : TEMsgTransStateError;
    [[TECoreDataHelper defaultHelper] save];
}

@end
