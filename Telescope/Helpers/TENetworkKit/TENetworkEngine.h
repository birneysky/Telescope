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


/**
 网络状态枚举

 - UNKNOWN:    未初始化时的状态
 - RUNNING:    已连接正在运行
 - CLOSED:     连接已关闭
 - CONNECTING: 正在连接
 - CLOSING:    正在关闭连接
 */
typedef NS_ENUM(NSUInteger, TECONNECTION_STATUS){
    UNKNOWN,RUNNING,CLOSED,CONNECTING,CLOSING
};



/**
 与netty服务器网络交互服务类，当第一次与服务器交互时，才与服务器建立连接，
 如果使用过程中断开连接，不重连，直到下次网络交互发起时，才尝试重连。
 */
@interface TENetworkEngine : NSObject

/**
 当前与服务器网络状态
 */
@property (nonatomic,readonly) TECONNECTION_STATUS status;


/**
 初始化方法

 @param name 远程主机地址
 @param port 端口号

 @return TENetworkEngine 实例
 */
- (nonnull instancetype) initWithHostName:(nonnull NSString*)name port:(uint16_t)port;



/**
 使网络操作进入操作队列

 @param operation 操作对象实例
 */
- (void)enqueueOperation:(nonnull TENetworkOperation*)operation;


/**
 实例化操作对象方法

 @param packet 信令对象

 @return 操作对象实例
 */
- (nonnull TENetworkOperation*)operationWithParams:(nonnull V2PPacket*)packet;

@end
