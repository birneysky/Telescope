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
    __weak TECoreDataHelper* helper = [TECoreDataHelper defaultHelper];
    [helper.backgroundContext performBlock:^{
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TEChatSession"];
        NSPredicate* predicat = [NSPredicate predicateWithFormat:@"senderID == %@",sid];
        [fetchRequest setPredicate:predicat];
        NSError* error;
        NSArray* result = [helper.backgroundContext executeFetchRequest:fetchRequest error:&error];
        
        /*
         @property (nonatomic) int64_t senderID;
         @property (nonatomic) int64_t receiverID;
         @property (nullable, nonatomic, copy) NSString *content;
         @property (nullable, nonatomic, copy) NSDate *sendTime;
         @property (nonatomic) int16_t type;
         @property (nullable, nonatomic, copy) NSDate *recvTime;

         */
        TEMessage* message = [NSEntityDescription insertNewObjectForEntityForName:@"TEMessage" inManagedObjectContext:helper.backgroundContext];
        message.mid = gen_uuid();
        message.senderID = [sid longLongValue];
        message.receiverID = 100001;
        message.content = [NSString stringWithFormat:@"%@:%lu ---> self are you ok ",sid,index];
        message.sendTime = date;
        message.type = 0;
        message.recvTime = [NSDate date];
        
        TEChatSession* session = nil;
        
        if (result.count == 0) {
            
            /*
             @property (nonatomic) int64_t groupID;
             @property (nonatomic) int16_t groupType;
             @property (nonatomic) int64_t senderID;
             @property (nullable, nonatomic, copy) NSDate *timeToRecvLastMessage;
             @property (nullable, nonatomic, copy) NSString *overviewOfLastMessage;
             @property (nonatomic) int16_t lastMessageType;

             */
            session  = [NSEntityDescription insertNewObjectForEntityForName:@"TEChatSession" inManagedObjectContext:helper.backgroundContext];
            session.groupID = 0;
            session.groupType = 0;
            session.senderID = [sid longLongValue];
            session.timeToRecvLastMessage = [NSDate date];
            session.overviewOfLastMessage = [NSString stringWithFormat:@"%@:%lu ---> self are you ok ",sid,index];
            session.lastMessageType = message.type;
            
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
        
        message.session = session;
        
        [helper saveBackgroundContext];
        NSDate* ttDate = [NSDate date];
        if( [ttDate timeIntervalSinceDate:self.previousdate] > 3){
            self.previousdate = ttDate;
            //[helper.backgroundContext refreshAllObjects];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
            //[helper.backgroundContext refreshAllObjects];
        }
        
        //[helper.backgroundContext refreshObject:message mergeChanges:NO];
        //[helper.backgroundContext refreshObject:session mergeChanges:NO];
        //NSLog(@"backgroundContext managed object count = %lu",[[helper.backgroundContext registeredObjects] count]);


        [helper.backgroundContext refreshAllObjects];
        
    }];
    
    
    
}

#pragma mark - *** api ***
- (void)start
{
    NSArray<NSNumber*>* usrIDs = @[@100001,@100002/*,@100003,@100004,@100005,@100006,@100007,@100008,@100009,@100010,@100011,@100012,@100013,@100014,@100015,@100016,@100017,@100018,@100019,@100020,@100021,@100022,@100023,@100024,@100025,@100026,@100027,@100028*/];
    NSArray<NSString*>* names = @[@"张一☂️",@"张二🍐"/*,@"张三♥️",@"张四🍎",@"张五",@"张六",@"张七",@"张八",@"张九",@"李一",@"李二",@"李三",@"李四",@"李五",@"李六",@"🍐七",@"🍐八",@"🍐九",@"🍎一",@"🍎二",@"🍎三",@"🍎四",@"🍎屋",@"☂️一",@"☂️二",@"☂️三",@"☂️四",@"☂️五"*/];
    self.runing = YES;
    
    TECoreDataHelper* helper = [TECoreDataHelper defaultHelper];
    
    [usrIDs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError* error;
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"TECacheUser"];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"uid == %lld",[obj longLongValue]];
        [request setPredicate:predicate];
        NSArray* arry =  [helper.defaultContext executeFetchRequest:request error:&error];
        if (arry.count == 0) {
            TECacheUser* user = [NSEntityDescription insertNewObjectForEntityForName:@"TECacheUser" inManagedObjectContext:helper.defaultContext];
            user.uid = [obj longLongValue];
            user.nickName = names[idx];
        }
    }];
    
    [helper saveDefaultContext];

    __weak TEMessageFactory* weakSelf = self;
    dispatch_async(self.workQueue, ^{
        NSUInteger count = 0;
        NSPort* dummyPort = [NSMachPort port];
        [[NSRunLoop currentRunLoop] addPort:dummyPort forMode:NSDefaultRunLoopMode];
        while (weakSelf.runing) {
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            NSLog(@"🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂🐂");
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



@end
