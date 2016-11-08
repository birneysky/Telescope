//
//  TENetworkOperation.m
//  Telescope
//
//  Created by zhangguang on 16/10/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <ProtocolBuffers/ProtocolBuffers.h>
#import "TENetworkOperation.h"


typedef NS_ENUM(NSInteger, TENetworkOperationState) {
    TENetworkOperationStateReady = 1,
    TENetworkOperationStateExecuting = 2,
    TENetworkOperationStateFinished = 3
};


@interface TENetworkOperation ()

@property (nonatomic,copy) V2PPacket* responseData;

@property (nonatomic,assign) TENetworkOperationState state;

@property (nonatomic,weak) id target;

@property (nonatomic,assign) SEL executionSelector;

@property (nonatomic,copy) TENKCompletedBlock completedBlock;

@property (nonatomic,copy) TENKErrorBlock errorBlock;

@end

@implementation TENetworkOperation
{
    BOOL _executing;  // 执行中
    BOOL _finished;   // 已完成
    BOOL _canceled; //已取消
}

- (void)dealloc{
    NSLog(@"♻️♻️♻️♻️ TENetworkOperation ~ %@ ",self);
}

- (void)setTarget:(id)target executionSelector:(SEL)selector
{
    self.target = target;
    self.executionSelector = selector;
}


-(void) setCompletionHandler:(TENKCompletedBlock) completion errorHandler:(TENKErrorBlock) error
{
    self.completedBlock = completion;
    self.errorBlock = error;
}

- (void) operationFailedWithError:(NSError*) error
{
    if (self.errorBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.errorBlock(error);
        });
    }
    [self cancel];
    [self completeOperation];
}

- (void)operationSucceeded:(V2PPacket*)packet
{
    self.responseData = packet;
    if (self.completedBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completedBlock(self);
        });
        
    }
    [self completeOperation];
}

#pragma mark - *** Override ***


- (void)start{
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [self main];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main{

    @try {

        BOOL taskIsFinished = NO;
 
        while (taskIsFinished == NO && [self isCancelled] == NO){

//            if([self.target respondsToSelector:self.executionSelector]){
//                objc_msgSend(self.target,self.executionSelector,data);
            if (self.excuteBlock) {
                self.excuteBlock();
            }
            
            taskIsFinished = YES;
        }

//        if ([self isCancelled]) {
//            [self operationFailedWithError:nil];
//        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception %@", e);
    }

}


- (void)completeOperation {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];
}


- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isCancelled{
    return _canceled;
}

- (void)cancel{
    [self willChangeValueForKey:@"isCancelled"];
    _canceled = NO;
    [self didChangeValueForKey:@"isCancelled"];
    [super cancel];
}

@end
