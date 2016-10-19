//
//  NettyNetWorkEngine.h
//  Telescope
//
//  Created by Showers on 16/9/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//


/*
 *  负责发送数据和接受数据的，处理断线重连，心跳等。
 */

#import <Foundation/Foundation.h>
#import "TENetworkOperation.h"

@class V2PPacket;

@interface TENetworkEngine : NSObject

- (instancetype) initWithHostName:(NSString*)name port:(uint16_t)port;


- (TENetworkOperation*) operationWithParams:(V2PPacket*)packet;


- (void)enqueueOperation:(TENetworkOperation*)operation;


//- (void) sendData:(NSData *)data;
//
//- (BOOL)connectToHost:(NSString*)host onPort:(uint16_t)port error:(NSError **)errPtr;
//
//- (void)disconnect;

@end
