//
//  TEMessageFactory.m
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEMessageFactory.h"
#import "TECoreDataHelper.h"
#import "TEMessage+CoreDataProperties.h"
#import "TEChatSession+CoreDataProperties.h"
#import "TECacheUser+CoreDataProperties.h"
#import "XMLDictionary.h"
#import "TEChatXMLReader.h"

@interface TEMessageFactory ()

@property (nonatomic,strong) dispatch_queue_t workQueue;

@property (nonatomic,assign) BOOL runing;

@property( nonatomic,strong) NSDate* previousdate;


@end


//NSString* uuid = [[NSUUID UUID] UUIDString];
NSString* gen_uuid()
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    
    CFRelease(uuid_string_ref);
    
    return uuid;
    
}

@implementation TEMessageFactory

#pragma mark - *** Properties ***
- (dispatch_queue_t) workQueue
{
    if (!_workQueue) {
        _workQueue  = dispatch_queue_create("com.Telescope.messageFactory", DISPATCH_QUEUE_SERIAL);
    }
    return _workQueue;
}

#pragma makr - *** ****
- (void)produceMessagesWithSenderID:(NSNumber*)sid index:(NSUInteger)index sendTime:(NSDate*)date;
{
    __weak NSManagedObjectContext* weakContext = [TECoreDataHelper defaultHelper].backgroundContext;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TEChatSession"];
    NSPredicate* predicat = [NSPredicate predicateWithFormat:@"remoteUsrID == %lld",[sid longLongValue]];
    [fetchRequest setPredicate:predicat];
    NSError* error;
    NSArray* result = [weakContext executeFetchRequest:fetchRequest error:&error];
    [weakContext performBlock:^{

        
        /*
         @property (nonatomic) int64_t senderID;
         @property (nonatomic) int64_t receiverID;
         @property (nullable, nonatomic, copy) NSString *content;
         @property (nullable, nonatomic, copy) NSDate *sendTime;
         @property (nonatomic) int16_t type;
         @property (nullable, nonatomic, copy) NSDate *recvTime;

         */
        
        TEChatMessage* chatMessage = [[TEChatMessage alloc] init];
        chatMessage.isAutoReply = NO;
        chatMessage.messageID = gen_uuid();
        
        
        BOOL isProduceText = arc4random() % 2 == 0 ? YES : NO;
        if (isProduceText) {
            TEMsgTextSubItem* textItem = [[TEMsgTextSubItem alloc] initWithType:Text];
            textItem.textContent = @"念小编有一个好消息要告诉大家，我们的“老外说”终于要回归了！";
            [chatMessage addItem:textItem];
        }
        
        if (isProduceText) {
            for (int i = 0;  i < arc4random() % 10; i++) {
                TEExpresssionSubItem* faceItem = [[TEExpresssionSubItem alloc] initWithType:Face];
                faceItem.frame = CGRectMake(0, 0, 24, 24);
                NSUInteger expressionIndex = arc4random() % 105;
                //NSString* path = [[NSBundle mainBundle] pathForResource:@"TEExpression" ofType:@"bundle"];
                NSString* itemName = [NSString stringWithFormat:@"%ld",expressionIndex];
                //NSString* imageName = [path stringByAppendingPathComponent:itemName];
                faceItem.fileName = itemName;
                [chatMessage addItem:faceItem];
                
                TEMsgTextSubItem* textItem = [[TEMsgTextSubItem alloc] initWithType:Text];
                textItem.textContent = @"把每个角落刻满你我的名字 闪烁着光芒就像宝石那样子 一同经历过磨砺万次 ";
                [chatMessage addItem:textItem];
            }
        }
        
        BOOL isproduceLink = arc4random() % 2 == 0 ? YES : NO;
        if (isproduceLink) {
            TEMsgLinkSubItem* linkItem = [[TEMsgLinkSubItem alloc] initWithType:Link];
            linkItem.url = @"www.baidu.com";
            [chatMessage addItem:linkItem];
        }
        
        if (isproduceLink) {
            TEExpresssionSubItem* faceItem = [[TEExpresssionSubItem alloc] initWithType:Face];
            faceItem.frame = CGRectMake(0, 0, 24, 24);
            NSUInteger expressionIndex = arc4random() % 105;
            NSString* path = [[NSBundle mainBundle] pathForResource:@"TEExpression" ofType:@"bundle"];
            NSString* itemName = [NSString stringWithFormat:@"Expression_%ld",expressionIndex];
            NSString* imageName = [path stringByAppendingPathComponent:itemName];
            faceItem.fileName = imageName;
            [chatMessage addItem:faceItem];
        }
        

        
        TEMsgTextSubItem* textItem = [[TEMsgTextSubItem alloc] initWithType:Text];
        textItem.textContent = [NSString stringWithFormat:@"%@:%lu ---> self are you ok",sid,index];
        [chatMessage addItem:textItem];
        
        
        NSString* content = [chatMessage xmlString];
        TEMessage* message = [NSEntityDescription insertNewObjectForEntityForName:@"TEMessage" inManagedObjectContext:weakContext];
        message.mID = chatMessage.messageID;
        message.senderID = [sid longLongValue];
        message.receiverID = 100001;
        message.content = content;
        message.sendTime = date;
        message.type = 0;
        message.recvTime = [NSDate date];
        
        //NSLog(@"context Xml %@",content);
        
        TEChatSession* session = nil;
        
        if (result.count == 0) {
            NSInteger sessionCount = [weakContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"TEChatSession"] error:nil];
            session  = [NSEntityDescription insertNewObjectForEntityForName:@"TEChatSession" inManagedObjectContext:weakContext];
            session.groupID = 0;
            session.groupType = 0;
            session.remoteUsrID = [sid longLongValue];
            session.timeToRecvLastMessage = [NSDate date];
            session.overviewOfLastMessage = [NSString stringWithFormat:@"%@:%lu ---> self are you ok",sid,index];
            session.lastMessageType = message.type;
            session.sID = (int32_t)sessionCount + 1;
            //session.sID = (int32_t)[sid longLongValue];
        }
        else if (1 == result.count){
            session = result.firstObject;
            session.timeToRecvLastMessage = [NSDate date];
            session.lastMessageType = message.type;
            //[session addMessagesObject:message];
        }
        else{
            assert(0);
        }
        
        message.sessionID = session.sID;
        session.totalNumOfMessage += 1;
        
        [message layout];
//        if ([weakContext hasChanges]) {
//            NSError* error;
//            [weakContext save:&error];
//        }

        [[TECoreDataHelper defaultHelper] saveBackgroundContext];
        NSDate* ttDate = [NSDate date];
        if( [ttDate timeIntervalSinceDate:self.previousdate] > 3){
            self.previousdate = ttDate;
            //[weakContext refreshAllObjects];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
            //[helper.backgroundContext refreshAllObjects];
        }
        
        //[helper.backgroundContext refreshObject:message mergeChanges:NO];
        //[helper.backgroundContext refreshObject:session mergeChanges:NO];
        //NSLog(@"backgroundContext managed object count = %lu",[[helper.backgroundContext registeredObjects] count]);


        //[helper.backgroundContext refreshAllObjects];
        
    }];
    
    
    
//    NSString* message =  @"<TChatData IsAutoReply=\"False\" MessageID=\"2CA31945-7DCD-4552-9673-EC6A38065C70\"><ItemList><TLinkTextChatItem NewLine=\"True\" FontIndex=\"0\" Text=\"www.baidu.com\" GroupGUID=\"\" LinkType=\"lteHttp\" URL=\"www.baidu.com\"/><TTextChatItem NewLine=\"False\" FontIndex=\"1\" Text=\"  wo范德萨了附近的拉萨解放了多少房间打扫垃圾分类的撒娇法律框架大使来访记录的撒激烈反抗附近的撒离开房间里的撒娇了\"/></ItemList></TChatData>";
//    TEChatMessage* messageModel = [TEChatXMLReader messageForXmlString:message error:nil];
//    
//    //NSDictionary* dic = [NSDictionary dictionaryWithXMLString:message];
//    
//    
//    NSDictionary* messageDic = [messageModel toDictionary];
//    NSString* xml = [messageDic XMLString];
//    
//    TEChatMessage* message2 = [TEChatXMLReader messageForXmlString:xml error:nil];
//    TEXmlMessage* xmlMessage = [[TEXmlMessage alloc] initWithDictionary:dic];
//    NSLog(@"dic %@",dic);
}

#pragma mark - *** api ***
- (void)start
{
    NSArray<NSNumber*>* usrIDs = @[@100001,@100002,@231/*,@100004,@100005,@100006,@100007,@100008,@100009,@100010,@100011,@100012,@100013,@100014,@100015,@100016,@100017,@100018,@100019,@100020,@100021,@100022,@100023,@100024,@100025,@100026,@100027,@100028*/];
    NSArray<NSString*>* names = @[@"张一☂️",@"张二🍐",@"张三♥️"/*,@"张四🍎",@"张五",@"张六",@"张七",@"张八",@"张九",@"李一",@"李二",@"李三",@"李四",@"李五",@"李六",@"🍐七",@"🍐八",@"🍐九",@"🍎一",@"🍎二",@"🍎三",@"🍎四",@"🍎屋",@"☂️一",@"☂️二",@"☂️三",@"☂️四",@"☂️五"*/];
    self.runing = YES;
    
    TECoreDataHelper* helper = [TECoreDataHelper defaultHelper];
    
    [usrIDs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError* error;
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"TECacheUser"];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"uid == %lld",[obj longLongValue]];
        [request setPredicate:predicate];
        NSArray* arry =  [helper.defaultContext executeFetchRequest:request error:&error];
        if (arry.count == 0) {
            TECacheUser* user = [NSEntityDescription insertNewObjectForEntityForName:@"TECacheUser" inManagedObjectContext:helper.backgroundContext];
            user.uid = [obj longLongValue];
            user.nickName = names[idx];
        }
    }];
    
    
    __weak NSManagedObjectContext* weakContext = [TECoreDataHelper defaultHelper].backgroundContext;
    [weakContext performBlock:^{
         //[[TECoreDataHelper defaultHelper] saveBackgroundContext];
        if ([weakContext hasChanges]) {
                NSError* error;
                [weakContext save:&error];
        }
    }];
    //[helper saveBackgroundContext];

    __weak TEMessageFactory* weakSelf = self;
    dispatch_async(self.workQueue, ^{
        NSUInteger count = 0;
        NSPort* dummyPort = [NSMachPort port];
        [[NSRunLoop currentRunLoop] addPort:dummyPort forMode:NSDefaultRunLoopMode];
        while (weakSelf.runing) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            //[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            //NSLog(@"🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂");
            NSInteger randomIndex = arc4random() % [usrIDs count];
            [self produceMessagesWithSenderID:usrIDs[randomIndex] index:count++ sendTime:[NSDate date]];
        }
        [[NSRunLoop currentRunLoop] removePort:dummyPort forMode:NSDefaultRunLoopMode];
        self.workQueue = nil;
        
    });
    
    self.previousdate = [NSDate date];
}

- (void)stop
{
    self.runing = NO;
//    __weak TEMessageFactory* weakSelf = self;
//    dispatch_async(self.workQueue, ^{
//        weakSelf.runing = NO;
//    });
}

- (void)dealloc
{
    //dispatch_release(self.workQueue);
}

- (NSArray<NSString*>*)messages
{
    return nil;
}

@end
