//
//  TENetworkOperation.h
//  Telescope
//
//  Created by zhangguang on 16/10/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TENetworkOperation;

typedef void (^TENKCompletedBlock)(TENetworkOperation* operation);
typedef void (^TENKErrorBlock)( NSError* error);


@interface TENetworkOperation : NSOperation

@property (nonatomic,copy,readonly) TENKCompletedBlock completedBlock;

@property (nonatomic,copy,readonly) TENKErrorBlock errorBlock;

@property (nonatomic,copy,readonly) NSData* responseData;

@property (copy, nonatomic) NSString* certificate;


- (void)setPostedData:(NSData*)data;


- (void)addTarget:(id)target executionSelector:(SEL)selector;


- (void)setCompletionHandler:(TENKCompletedBlock) completion errorHandler:(TENKErrorBlock) error;


- (void)operationFailedWithError:(NSError*) error;


- (void)operationSucceeded:(NSData*)data;

@end
