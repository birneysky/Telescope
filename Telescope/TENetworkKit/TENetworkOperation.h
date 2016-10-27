//
//  TENetworkOperation.h
//  Telescope
//
//  Created by zhangguang on 16/10/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TENetworkOperation;
@class V2PPacket;

typedef void (^TENKCompletedBlock)(TENetworkOperation* operation);
typedef void (^TENKErrorBlock)( NSError* error);
typedef void (^TENKExecutionBlock)();

@interface TENetworkOperation : NSOperation

@property (nonatomic,copy,readonly) TENKCompletedBlock completedBlock;

@property (nonatomic,copy,readonly) TENKErrorBlock errorBlock;

@property (nonatomic,copy,readonly) V2PPacket* responseData;

@property (copy, nonatomic) NSString* certificate;

@property (nonatomic,copy) TENKExecutionBlock excuteBlock;

@property (nonatomic,strong) V2PPacket* postedPacket;


- (void)setTarget:(id)target executionSelector:(SEL)selector;


- (void)setCompletionHandler:(TENKCompletedBlock) completion errorHandler:(TENKErrorBlock) error;


- (void)operationFailedWithError:(NSError*) error;


- (void)operationSucceeded:(V2PPacket*)packet;

@end
