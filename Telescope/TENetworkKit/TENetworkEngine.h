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
typedef NS_ENUM(NSUInteger, TECONNECTION_STATUS){
    UNKNOWN,RUNNING,CLOSED,CONNECTING,CLOSING
};

@interface TENetworkEngine : NSObject


@property (nonatomic,readonly) TECONNECTION_STATUS status;


- (nonnull instancetype) initWithHostName:(nonnull NSString*)name port:(uint16_t)port;


- (void)enqueueOperation:(nonnull TENetworkOperation*)operation;


- (nonnull TENetworkOperation*)operationWithParams:(nonnull V2PPacket*)packet;

@end
