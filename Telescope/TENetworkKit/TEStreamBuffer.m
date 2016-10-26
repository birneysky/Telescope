//
//  TEStreamBuffer.m
//  Telescope
//
//  Created by Showers on 16/9/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEStreamBuffer.h"


#define PER_ALLOC_SIZE 8192

@interface TEStreamBuffer ()

@property (nonatomic,strong) NSMutableData* streamData;

@property (nonatomic,strong) NSMutableArray<NSData*>* netPacketArray;

@property (nonatomic,strong) dispatch_queue_t processPacketQueue ;

@property (nonatomic,strong) NSMutableArray<NSData*>* localPacketArray;

@end

@implementation TEStreamBuffer

#pragma mark - *** Properties ***

- (NSMutableArray<NSData*>*)netPacketArray
{
    if (!_netPacketArray) {
        _netPacketArray = [[NSMutableArray alloc] initWithCapacity:PER_ALLOC_SIZE];
    }
    return _netPacketArray;
}

- (NSMutableArray<NSData*>*)localPacketArray
{
    if (!_localPacketArray) {
        _localPacketArray = [[NSMutableArray alloc] init];
    }
    return _localPacketArray;
}

- (NSMutableData*)streamData
{
    if (!_streamData) {
        _streamData = [[NSMutableData alloc] initWithCapacity:PER_ALLOC_SIZE];
    }
    return _streamData;
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
    //NSMutableData* packetData = [[NSMutableData alloc] init];

    return nil;
}

- (void) appendData:(NSData*)data
{
    __weak TEStreamBuffer* weakSelf = self;
    dispatch_async(self.processPacketQueue, ^{
        //[weakSelf.netPacketArray addObject:data];
        [weakSelf.streamData appendData:data];
        [weakSelf processPacket];
    });
    
}

- (void)processPacket{
    __weak TEStreamBuffer* weakSelf = self;

    //NSLog(@"recv stream %@ len %ld",weakSelf.streamData,(long)weakSelf.streamData.length);
    NSInteger readOffset = 0;
    NSInteger streamDataLength = weakSelf.streamData.length;
    int8_t* streamBuffer = weakSelf.streamData.mutableBytes;
    while (readOffset < streamDataLength) {
        @autoreleasepool {
            NSInteger offset = 0;
            int8_t* buffer = streamBuffer + readOffset;
            NSInteger remainLenght = streamDataLength - readOffset;
            NSInteger packetLen = [weakSelf parseBufferHeader:buffer len:remainLenght offset:&offset];
            if (0 == packetLen) {
                return;
            }
            if (remainLenght >= packetLen+ offset) {
                NSData* data = [weakSelf.streamData subdataWithRange:NSMakeRange(readOffset+offset + 1, packetLen)];
                readOffset += packetLen + offset + 1;
                //解析数据;
                //NSLog(@"object %@ len %ld",data,(long)data.length);
                NSError* error;
                V2PPacket* V2packet = [V2PPacket parseFromData:data  error:&error];
                if (!error) {
                    //NSLog(@" reponse %@",V2packet);
                    if ([self.delegate respondsToSelector:@selector(didParsePacket:)]) {
                        [self.delegate didParsePacket:V2packet];
                    }
                }
                else{
                    NSLog(@"%@",error);
                    //assert(0);
                }
            }else{
                //
                NSData* data = [weakSelf.streamData subdataWithRange:NSMakeRange(readOffset, remainLenght)];
                [weakSelf.streamData replaceBytesInRange:NSMakeRange(0, data.length) withBytes:data.bytes];
                weakSelf.streamData.length = data.length;
                //self.streamData = [[NSMutableData alloc] initWithData:data];
                break;
            }
        }


    }
    
    
    if (readOffset == streamDataLength) {
        if (readOffset > PER_ALLOC_SIZE) {
            weakSelf.streamData = [[NSMutableData alloc] initWithCapacity:PER_ALLOC_SIZE];
        }
        else{
            weakSelf.streamData.length = 0;
  
        }
    }
}


- (NSInteger) parseBufferHeader:(int8_t*)buffer len:(NSInteger)length offset:(NSInteger*)offset{
    if (length <= 0) {
        return 0;
    }
   // int8_t* buffer = (int8_t*)data.bytes;
    *offset = 0;
    int8_t tmp = buffer[*offset];
    if (tmp >= 0) {
        return tmp;
    } else {
        int result = tmp & 127;
        (*offset) ++;
        if ((*offset) >= length) {
            return 0;
        }
        //判断流数据中是否还有数据
        if ((tmp = buffer[*offset]) >= 0) {
            result |= tmp << 7;
        } else {
            result |= (tmp & 127) << 7;
            //判断流数据中是否还有数据
            (*offset) ++;
            if ((*offset) >= length) {
                return 0;
            }
            if ((tmp = buffer[*offset]) >= 0) {
                result |= tmp << 14;
            } else {
                result |= (tmp & 127) << 14;
                //判断流数据中是否还有数据
                (*offset) ++;
                if ((*offset) >= length) {
                    return 0;
                }
                if ((tmp = buffer[*offset]) >= 0) {
                    result |= tmp << 21;
                } else {
                    result |= (tmp & 127) << 21;
                    //判断流数据中是否还有数据
                    (*offset) ++;
                    if ((*offset) >= length) {
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


void BinaryPrint(int n)
{
    for (int i=31;i >=0; i--)
    {
        if ((i+1) % 8 == 0 && i != 0) {
            printf(" ");
        }
        printf("%d",(n >> i)&1);
        
    }
    printf("\n");
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
@end
