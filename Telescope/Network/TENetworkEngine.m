//
//  NettyNetWorkEngine.m
//  Telescope
//
//  Created by zhangguang on 16/9/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TENetworkEngine.h"
#import <CocoaAsyncSocket/CocoaAsyncSocket.h>

@interface TENetworkEngine () <GCDAsyncSocketDelegate>

@property (nonatomic,strong)  GCDAsyncSocket* asyncSocket;

@property (nonatomic,strong) NSOutputStream* outputStream;

@property (nonatomic,strong) NSMutableData* streamData;

@end

@implementation TENetworkEngine

#pragma mark - *** Properties ***
- (GCDAsyncSocket*) asyncSocket
{
    if (!_asyncSocket) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return _asyncSocket;
}

- (NSOutputStream*) outputStream
{
    if (!_outputStream) {
        _outputStream = [[NSOutputStream alloc] initToMemory];
    }
    return _outputStream;
}


#pragma mark - *** Api ***

- (void) sendData:(NSData *)data
{
    NSInteger lenght = data.length;
    NSMutableData* sendData = [[NSMutableData alloc] initWithCapacity:data.length + 4];
    while (true) {
        if ((lenght & ~0x7F) == 0) {
            int8_t value = (int8_t)lenght;
            [sendData appendBytes:&value length:sizeof(value)];
            break;
        } else {
            int8_t value = (lenght & 0x7F) | 0x80;
            [sendData appendBytes:&value length:sizeof(value)];
            lenght >>= 7;
        }
    }
    [sendData appendData:data];
    [self.asyncSocket writeData:[sendData copy] withTimeout:-1 tag:1000];
}

#pragma mark - *** ***



- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"Connect to server successfully %@:%d",host,port);
    //启动心跳 定制器
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"didReadData  %@,length %ld",data,(long)data.length);
    
    
    
    //    NSString* test = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    //    NSLog(@"string %@",test);
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataWithTimeout:10 tag:tag];
    NSLog(@"didWriteDataWithTag");
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    NSLog(@"didReceiveTrust");
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didReadPartialDataOfLength");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    NSLog(@"socketDidDisconnect");
}

- (NSInteger) computeByteSizeForInt32:(int32_t) value{
    if ((value & (0xffffffff <<  7)) == 0) {
        return 1;
    }
    if ((value & (0xffffffff << 14)) == 0) {
        return 2;
    }
    if ((value & (0xffffffff << 21)) == 0) {
        return 3;
    }
    if ((value & (0xffffffff << 28)) == 0) {
        return 4;
    }
    return 5;
}



- (NSInteger) parsePacketLength:(NSData*) data offset:(NSInteger*)offset{
    if (data.length <= 0) {
        return 0;
    }
    int8_t* buffer = (int8_t*)data.bytes;
    *offset = 0;
    int8_t tmp = buffer[*offset];
    if (tmp >= 0) {
        return tmp;
    } else {
        int result = tmp & 127;
        (*offset) ++;
        if ((*offset) >= data.length) {
            return 0;
        }
        //判断流数据中是否还有数据
        if ((tmp = buffer[*offset]) >= 0) {
            result |= tmp << 7;
        } else {
            result |= (tmp & 127) << 7;
            //判断流数据中是否还有数据
            (*offset) ++;
            if ((*offset) >= data.length) {
                return 0;
            }
            if ((tmp = buffer[*offset]) >= 0) {
                result |= tmp << 14;
            } else {
                result |= (tmp & 127) << 14;
                //判断流数据中是否还有数据
                (*offset) ++;
                if ((*offset) >= data.length) {
                    return 0;
                }
                if ((tmp = buffer[*offset]) >= 0) {
                    result |= tmp << 21;
                } else {
                    result |= (tmp & 127) << 21;
                    //判断流数据中是否还有数据
                    (*offset) ++;
                    if ((*offset) >= data.length) {
                        return 0;
                    }
                    result |= (tmp = buffer[*offset]) << 28;
                    if (tmp < 0) {
                        assert(0);
                    }
                }
            }
        }
        return result;
    }
}

@end
