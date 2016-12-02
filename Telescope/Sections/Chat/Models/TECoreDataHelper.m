//
//  TECoreDataHelper.m
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TECoreDataHelper.h"

#define STOREFILENAME @"Telesope.sqlite"

static TECoreDataHelper* helper;

@interface TECoreDataHelper ()

@property (nonatomic,strong) NSPersistentStore* sotre;

@end

@implementation TECoreDataHelper

#pragma mark - *** Initializers ***
+ (TECoreDataHelper*)defaultHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[TECoreDataHelper alloc] init];
        [helper loadStore];
    });
    return helper;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (!helper) {
        return  helper = [super allocWithZone:zone];
    }
    return nil;
}

- (void)loadStore
{
    if (_sotre) {
        return;
    }
    
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _defaultContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    [_defaultContext setPersistentStoreCoordinator:_coordinator];
    
    _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _backgroundContext.stalenessInterval = 10000;
    [_backgroundContext performBlockAndWait:^{
        [_backgroundContext setPersistentStoreCoordinator:_coordinator];
        [_backgroundContext setUndoManager:nil];
    }];
    
    NSDictionary* options = @{NSSQLitePragmasOption:@{@"journal_mode":@"DELETE"},
                              NSMigratePersistentStoresAutomaticallyOption:@YES,
                              NSInferMappingModelAutomaticallyOption:@YES
                              };
    NSError* error;
    _sotre = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:[self storeURL]
                                              options:options
                                                error:&error];

}

#pragma mark - *** Path Helpers ***

- (NSString*)appDocumentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSURL*)appStorePath
{
    NSURL* storeURL = [[NSURL fileURLWithPath:[self appDocumentPath]] URLByAppendingPathComponent:@"Stores"];
    
    //如果没有该目录，创建该目录
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:storeURL.path ]) {
        NSError* error;
        if ( [fileManager createDirectoryAtURL:storeURL
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:&error]) {
            DDLogInfo(@"成功创建stores目录");
        }
        else{
            DDLogInfo(@"创建stores目录失败: %@",error);
        }
    }
    
    return storeURL;
}

- (NSURL*) storeURL
{
    return [[self appStorePath] URLByAppendingPathComponent:STOREFILENAME];
}


#pragma mark - *** Saving ***

- (void)saveContext:(NSManagedObjectContext*)context
{
    if ([context hasChanges]) {
        NSError* error;
        if ([context save:&error]) {
            // TRACE(@"保存改变的数据到持久化存储区");
        }
        else{
            DDLogInfo(@"默认托管上下文保存失败:%@",error);
        }
    }
    else{
        DDLogInfo(@"数据没有变化，不需要保存");
    }
}

- (void)saveDefaultContext
{
    [self saveContext:self.defaultContext];
}

- (void)saveBackgroundContext{
    [self saveContext:self.backgroundContext];
}

@end
