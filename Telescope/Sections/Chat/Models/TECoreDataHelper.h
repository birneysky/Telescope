//
//  TECoreDataHelper.h
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/**
 持久化存储
 */
@interface TECoreDataHelper : NSObject

@property (nonatomic,readonly) NSManagedObjectModel* model;

@property (nonatomic,readonly) NSManagedObjectContext* defaultContext;

@property (nonatomic,readonly) NSManagedObjectContext* backgroundContext;

@property (nonatomic,readonly) NSPersistentStoreCoordinator* coordinator;

+ (TECoreDataHelper*)defaultHelper;

- (void)saveDefaultContext;

- (void)saveBackgroundContext;


@end
