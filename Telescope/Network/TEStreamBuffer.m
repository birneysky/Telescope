//
//  TEStreamBuffer.m
//  Telescope
//
//  Created by zhangguang on 16/9/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEStreamBuffer.h"

@interface TEStreamBuffer ()

@property (nonatomic,strong) NSMutableArray<NSData*>* packetArray;

@property (nonatomic,strong) dispatch_queue_t processPacketQueue ;
@end


@implementation TEStreamBuffer


#pragma mark - *** Properties ***

- (NSMutableArray<NSData*>*)packetArray
{
    if (!_packetArray) {
        _packetArray = [[NSMutableArray alloc] initWithCapacity:1000];
    }
    return _packetArray;
}

- (dispatch_queue_t) processPacketQueue
{
    if (!_processPacketQueue) {
        _processPacketQueue = dispatch_queue_create("com.queue.processPacket", DISPATCH_QUEUE_SERIAL);;
    }
    return _processPacketQueue;
}

#pragma mark - *** Api ***
- (NSData*)readSliceData:(NSInteger) lenght offset:(NSInteger) offset;
{
    for ( int i = 0; i < self.packetArray.count; ) {
        NSData* packet = self.packetArray[i];
        if (packet.length > lenght+ offset) {
            NSData* data = [packet subdataWithRange:NSMakeRange(offset, lenght)];
            NSInteger remianLength = data.length - (offset + lenght);
            NSData* remain = [packet subdataWithRange:NSMakeRange(offset + lenght, remianLength)];
        }
        else if (packet.length == lenght + offset){
            NSData* data = [packet subdataWithRange:NSMakeRange(offset, lenght)];
            [self.packetArray removeObjectAtIndex:i];
            return data;
        }
        else{
            
        }
        
    }
    return nil;
}

- (void) appendData:(NSData*)data
{
    __weak TEStreamBuffer* weakSelf = self;
    dispatch_async(self.processPacketQueue, ^{
        [weakSelf.packetArray addObject:data];
    });
    [self processPacket];
}

- (void)processPacket{
    __weak TEStreamBuffer* weakSelf = self;
    dispatch_async(self.processPacketQueue, ^{
        //NSMutableData* packetHeader = [[NSMutableData alloc] initWithCapacity:5];
        NSData* packet = weakSelf.packetArray.firstObject;
        NSInteger Offset = 0;
        NSInteger packetLen = [weakSelf parsePacketLength:packet offset:&Offset];
        if (packetLen > 0) {
            //
            
        }
        else{
            //
        }
        
    });
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
