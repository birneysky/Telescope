//
//  NettyNetWorkEngine.m
//  Telescope
//
//  Created by Showers on 16/9/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TENetworkEngine.h"
#import "TEStreamBuffer.h"
#import <CocoaAsyncSocket/CocoaAsyncSocket.h>
#import <objc/objc.h>
#include <sys/time.h>
#import "TENetworkOperation.h"
#import "TEPacketDisPatcher.h"
#import "TENetworkOperation.h"


#define TAG_HEARTBEAT 1001
#define TAG_lOGIC 1002


static NSOperationQueue *_sharedNetworkQueue;


@interface TENetworkEngine () <GCDAsyncSocketDelegate>

@property (nonatomic,strong)  GCDAsyncSocket* asyncSocket;

@property (nonatomic,strong) NSOutputStream* outputStream;

@property (nonatomic,strong) NSMutableData* streamData;

@property (nonatomic,strong) TEStreamBuffer* streamBuffer;

@property (nonatomic,strong) TEPacketDisPatcher* packetDipatcher;

@property (nonatomic,weak) NSTimer* heartBeatTimer;

@property (nonatomic,assign) BOOL firstHeatBeatRecv;

@property (nonatomic,copy) NSString* houstName;

@property (nonatomic,assign) uint16_t port;

@end


NSString* gen_uuid()
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    
    CFRelease(uuid_string_ref);
    
    return uuid;
    
}


@implementation TENetworkEngine


+(void) initialize {
    
    if(!_sharedNetworkQueue) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _sharedNetworkQueue = [[NSOperationQueue alloc] init];
            [_sharedNetworkQueue addObserver:[self self] forKeyPath:@"operationCount" options:0 context:NULL];
            [_sharedNetworkQueue setMaxConcurrentOperationCount:4];
            
        });
    }
}

+ (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == _sharedNetworkQueue && [keyPath isEqualToString:@"operationCount"]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible =
        ([_sharedNetworkQueue.operations count] > 0);
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
    
    if(_sharedNetworkQueue.operations.count ==0){
        NSLog(@"All operations performed.");
    }
}

- (instancetype) initWithHostName:(NSString*)name port:(uint16_t)port
{
    if (self = [super init]) {
        self.houstName = name;
        self.port = port;
    }
    
    return self;
}

- (TENetworkOperation*) operationWithParams:(V2PPacket*)packet
{
    
    TENetworkOperation* op = [[TENetworkOperation alloc] init];
    packet.id_p = [NSString stringWithFormat:@"%@",op];
    [op addTarget:self executionSelector:@selector(sendData:)];
    return op;
}


- (void)enqueueOperation:(TENetworkOperation*)operation
{
    [_sharedNetworkQueue addOperation:operation];
}

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


- (TEPacketDisPatcher*) packetDipatcher{
    if (!_packetDipatcher) {
        _packetDipatcher = [[TEPacketDisPatcher alloc] init];
    }
    return _packetDipatcher;
}

- (TEStreamBuffer*)streamBuffer
{
    if (!_streamBuffer) {
        _streamBuffer = [[TEStreamBuffer alloc] init];
        _streamBuffer.delegate = self.packetDipatcher;
    }
    return _streamBuffer;
}

#pragma mark - *** Api ***

- (void) sendData:(NSData *)data
{
    [self sendData:data tag:TAG_lOGIC];
}

- (void) sendData:(NSData *)data tag:(NSInteger)tag
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
    [self.asyncSocket writeData:[sendData copy] withTimeout:-1 tag:tag];
}

- (BOOL)connectToHost:(NSString*)host onPort:(uint16_t)port error:(NSError **)errPtr
{
    //return [self.asyncSocket connectToHost:host onPort:port error:errPtr];
    return [self.asyncSocket connectToHost:host onPort:port withTimeout:10 error:errPtr];
}


- (void)disconnect
{
    [self.asyncSocket disconnect];
    
}
#pragma mark - *** ***



- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"Connect to server successfully %@:%d",host,port);
    //启动心跳 定制器
//    uint8_t bufLogin[54] = {0x35, 0x08, 0x00, 0x22,
//        0x01, 0x31, 0x2a, 0x05,
//        0x6c, 0x6f, 0x67, 0x69,
//        0x6e, 0x32, 0x07, 0x73,
//        0x6d, 0x73, 0x63, 0x6f,
//        0x64, 0x65, 0x42, 0x17,
//        0x4a,0x15, 0x12,  0x0b,
//        0x31, 0x35, 0x38, 0x31,
//        0x31, 0x30, 0x30, 0x34,
//        0x34, 0x39, 0x34, 0x2a,
//        0x06, 0x31, 0x31, 0x31,
//        0x31, 0x31, 0x31, 0x4a,
//        0x05, 0x31, 0x2e, 0x31,
//        0x2e, 0x30};

    V2PPacket* loginPacket = [[V2PPacket alloc] init];
    loginPacket.packetType = V2PPacket_type_Iq;
    loginPacket.id_p = gen_uuid();
    loginPacket.version = @"1.3.1";
    loginPacket.method = @"login";
    loginPacket.operateType = @"smscode";
    
    V2PData* data = [[V2PData alloc] init];
    V2PUser* user= [[V2PUser alloc] init];
    user.phone = @"15811004492";
    user.pwd2OrCode = @"111111";
    user.deviceId = @"12316546765164";
    [data.userArray addObject:user];
    loginPacket.data_p = data;
    
    
    //    //for (int i = 0; i < 10000; i++) {
//    [self sendData:[NSData dataWithBytes:bufLogin length:sizeof(bufLogin)] tag:TAG_lOGIC];
//   [self.asyncSocket writeData:[NSData dataWithBytes:bufLogin length:sizeof(bufLogin)] withTimeout:-1 tag:TAG_lOGIC];
   

    NSLog(@"login Packet id: %@ data: %@  len:%ld",loginPacket.id_p,loginPacket.data,(long)loginPacket.data.length);
    [self sendData:loginPacket.data tag:TAG_lOGIC];
    
    
    
    
    // [self.asyncSocket writeData:loginPacket.data withTimeout:-1 tag:TAG_lOGIC];
    //NSLog(@"send login done");
    //[sock readDataWithTimeout:10 tag:TAG_lOGIC];
        //}
    
    [self.asyncSocket readDataWithTimeout:-1 tag:TAG_lOGIC];
    self.heartBeatTimer =  [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(autoSendHeartbeat:) userInfo:nil repeats:YES];
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:self.heartBeatTimer forMode:NSDefaultRunLoopMode];
    [runloop run];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    [self.streamBuffer appendData:data];
    //NSLog(@"didReadData  %@,length %ld",data,(long)data.length);
    if (TAG_lOGIC == tag) {
        
    }
    else if(TAG_HEARTBEAT == tag){
        //NSLog(@"heart Bead %@ len %ld",data,(long)data.length);
//        if (!self.firstHeatBeatRecv) {
//            V2PPacket* loginPacket = [[V2PPacket alloc] init];
//            loginPacket.packetType = V2PPacket_type_Iq;
//            loginPacket.id_p = gen_uuid();
//            loginPacket.version = @"1.3.0";
//            loginPacket.method = @"login";
//            loginPacket.operateType = @"smscode";
//            
//            V2PData* data = [[V2PData alloc] init];
//            V2PUser* user= [[V2PUser alloc] init];
//            user.phone = @"15811004492";
//            user.pwd2OrCode = @"111111";
//            user.deviceId = @"12316546765164";
//            [data.userArray addObject:user];
//            loginPacket.data_p = data;
//            
//            NSLog(@"login Packet id: %@ data: %@  len:%ld",loginPacket.id_p,loginPacket.data,(long)loginPacket.data.length);
//            [self sendData:loginPacket.data tag:TAG_lOGIC];
//        }
//        self.firstHeatBeatRecv = YES;
    }
    else{
       // NSLog(@"unknow tag");
    }
    
    //[sock readDataWithTimeout:-1 tag:tag];
    
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didWritePartialDataOfLength");
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (TAG_lOGIC == tag) {
        NSLog(@"didWriteDataWithTag");
   }
//    else if(TAG_HEARTBEAT == tag){
//        NSLog(@"didWriteData Heartbeat");
//    }
    [sock readDataWithTimeout:-1 tag:tag];
    //NSLog(@"didWriteDataWithTag");
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    NSLog(@"didReceiveTrust");
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didReadPartialDataOfLength");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    [self.heartBeatTimer invalidate];
    self.firstHeatBeatRecv = NO;
    NSLog(@"socketDidDisconnect %@",err);
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    NSLog(@"socketDidCloseReadStream");
}


- (void)autoSendHeartbeat:(NSTimer*)timer
{

//   for( int i = 0 ;i < 10000;i ++){
       V2PPacket* packet = [[V2PPacket alloc] init];
       packet.packetType = V2PPacket_type_Beat;
       [self sendData:packet.data tag:TAG_HEARTBEAT];
//       uint8_t buffer[] = {0x08,0x03};
//       [self sendData:[NSData dataWithBytes:buffer length:sizeof(buffer)] tag:TAG_HEARTBEAT];
//   }
    
    //[self.asyncSocket writeData:packet.data withTimeout:1 tag:TAG_HEARTBEAT];
}


@end
