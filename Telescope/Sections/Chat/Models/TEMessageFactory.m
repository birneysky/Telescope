//
//  TEMessageFactory.m
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEMessageFactory.h"
#import "TECoreDataHelper.h"
#import "TEMessage.h"
#import "TECacheUser+CoreDataProperties.h"

@interface TEMessageFactory ()

@property (nonatomic,strong) dispatch_queue_t workQueue;

@property (nonatomic,assign) BOOL runing;

@end

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
- (void)produceMessages:(NSNumber*)userID index:(NSUInteger)index
{
    __weak TECoreDataHelper* helper = [TECoreDataHelper defaultHelper];
    [helper.backgroundContext performBlock:^{
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MessageSession"];
        NSPredicate* predicat = [NSPredicate predicateWithFormat:@"remoteUserID == %@",userID];
        [fetchRequest setPredicate:predicat];
        NSError* error;
        NSArray* result = [helper.backgroundContext executeFetchRequest:fetchRequest error:&error];
        
//        Message* message = [NSEntityDescription insertNewObjectForEntityForName:@"TEMessage" inManagedObjectContext:helper.backgroundContext];
//        message.fromUserID = userID;
//        message.content = [NSString stringWithFormat:@" %@ ---> self are you ok %lu",userID,index];
//        message.toUserID = @100;
//        MessageSession* session;
//        if (result.count  ==  0) {
//            session = [NSEntityDescription insertNewObjectForEntityForName:@"MessageSession" inManagedObjectContext:helper.backgroundContext];
//            session.remoteUserID =userID;
//            session.groupID = @0;
//            session.groupType = @0;
//            session.sendTime = [NSDate date];
//        }
//        else if (result.count == 1){
//            session = result.firstObject;
//            session.sendTime = [NSDate date];
//            message.session = result.firstObject;
//        }
//        else{
//            assert(0);
//        }
//        
//        [helper saveBackgroundContext];
//        
//        [helper.backgroundContext refreshObject:session mergeChanges:NO];
//        [helper.backgroundContext refreshObject:message mergeChanges:NO];
//        NSLog(@"backgroundContext managed object count = %lu",[[helper.backgroundContext registeredObjects] count]);
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
        
    }];
}

#pragma mark - *** api ***
- (void)start
{
    NSArray<NSNumber*>* usrIDs = @[@100001,@100002,@100003,@100004,@100005,@100006,@100007,@100008,@100009,@100010,@100011,@100012,@100013,@100014,@100015,@100016,@100017,@100018,@100019,@100020,@100021,@100022,@100023,@100024,@100025,@100026,@100027,@100028];
    NSArray<NSString*>* names = @[@"张一",@"张二",@"张三",@"张四",@"张五",@"张六",@"张七",@"张八",@"张九",@"李一",@"李二",@"李三",@"李四",@"李五",@"李六",@"🍐七",@"🍐八",@"🍐九",@"🍎一",@"🍎二",@"🍎三",@"🍎四",@"🍎屋",@"☂️一",@"☂️二",@"☂️三",@"☂️四",@"☂️五"];
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

//    __weak DataFactory* weakSelf = self;
//    dispatch_async(self.workQueue, ^{
//        NSUInteger count = 0;
//        NSPort* dummyPort = [NSMachPort port];
//        [[NSRunLoop currentRunLoop] addPort:dummyPort forMode:NSDefaultRunLoopMode];
//        while (weakSelf.runing) {
//            @autoreleasepool {
//                NSInteger index = arc4random() % [usrIDs count];
//                
//                [weakSelf produceMessages:usrIDs[index] index:count++];
//                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0f]];
//            }
//            
//        }
//    });
    
}

- (void)stop
{
    __weak TEMessageFactory* weakSelf = self;
    dispatch_async(self.workQueue, ^{
        weakSelf.runing = NO;
    });
}

- (void)dealloc
{
    //dispatch_release(self.workQueue);
}



@end
