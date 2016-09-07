//
//  ViewController.m
//  Telescope
//
//  Created by zhangguang on 16/9/2.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "ViewController.h"
#import <CocoaAsyncSocket/CocoaAsyncSocket.h>
#import <ProtocolBuffers/GPBProtocolBuffers.h>


@interface ViewController () <GCDAsyncSocketDelegate>

@property (nonatomic,strong)  GCDAsyncSocket* client;

@property (nonatomic,strong) NSMutableData* streamBuffer;

@end

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

@implementation ViewController


- (NSMutableData*)streamBuffer
{
    if (!_streamBuffer) {
        _streamBuffer = [[NSMutableData alloc] initWithCapacity:1024];
        [_streamBuffer increaseLengthBy:1024];
    }
    return _streamBuffer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int a = 0b00000000000000000000000000001001;
    int c = -9;
    int b = a >> 1;
    int d = c >> 1;
    BinaryPrint(b);
    BinaryPrint(c);
    BinaryPrint(d);
    V2PPacket* packet = [[V2PPacket alloc] init];
    packet.packetType = V2PPacket_type_Beat;
    
    NSData* data = packet.data;
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_queue_t queue = dispatch_queue_create("com.telescope.network", DISPATCH_QUEUE_SERIAL);
    self.client = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    self.client.delegate = self;
    NSError* error;
    [self.client connectToHost:@"123.57.20.30" onPort:9997 error:&error];
    NSLog(@"%@",data);
    
    NSInteger len = self.streamBuffer.length;

    int8_t temp = 0b10000001;
    if (temp >= 0) {
        //return temp
    }
    else{
        int result = temp & 127;
        temp = 0b00000001;
        if (temp >= 0) {
            result |= temp << 7;
        }
        else{
            result |= (temp & 127) << 7;
        }
    }
    NSLog(@"e %d",temp);
    BinaryPrint(temp);
    //NSTimer* timer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(autoSendHeartbeat:) userInfo:nil repeats:YES];
   // NSInputStream* stream  =  [NSInputStream alloc] initWithData:];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
     NSLog(@"成功连接到%@:%d",host,port);
    //uint8_t buf[3] = {0x02,0x08,0x03};
    uint8_t bufLogin[54] = {0x35, 0x08, 0x00, 0x22,
        0x01, 0x31, 0x2a, 0x05,
        0x6c, 0x6f, 0x67, 0x69,
        0x6e, 0x32, 0x07, 0x73,
        0x6d, 0x73, 0x63, 0x6f,
        0x64, 0x65, 0x42, 0x17,
        0x4a,0x15, 0x12,  0x0b,
        0x31, 0x35, 0x38, 0x31,
        0x31, 0x30, 0x30, 0x34,
        0x34, 0x39, 0x34, 0x2a,
        0x06, 0x31, 0x31, 0x31,
        0x31, 0x31, 0x31, 0x4a,
        0x05, 0x31, 0x2e, 0x31,
        0x2e, 0x30};
//    //[self.client write:[NSData dataWithBytes:buf length:3]];
//    //[self.client write:[NSData dataWithBytes:bufLogin length:54]];
//    //[self.client.socket readDataWithTimeout:100 tag:1000];
    [self.client readDataWithTimeout:10 tag:1000];
//    //for (int i = 0; i < 10000; i++) {
        [self.client writeData:[NSData dataWithBytes:bufLogin length:sizeof(bufLogin)] withTimeout:-1 tag:1000];
        NSLog(@"send login done");
    [sock readDataWithTimeout:10 tag:1000];
//    //}
   
    
   NSTimer* timer =  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoSendHeartbeat:) userInfo:nil repeats:YES];
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSDefaultRunLoopMode];
    [runloop run];
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//    dispatch_source_set_event_handler(timer, ^{
//        uint8_t buf[] = {0x02,0x08,0x03};
//        [self.client writeData:[NSData dataWithBytes:buf length:sizeof(buf)] withTimeout:5 tag:1000];
//    });
//    dispatch_resume(timer);
   
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"didReadData  %@,length %ld",data,(long)data.length);
    
//    NSString* test = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//    NSLog(@"string %@",test);
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didWritePartialDataOfLength");
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

- (void)autoSendHeartbeat:(NSTimer*)timer
{
//    uint8_t buf[] = {0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02,0x08,0x03,0x02};
//    [self.client writeData:[NSData dataWithBytes:buf length:sizeof(buf)] withTimeout:5 tag:1000];
    uint8_t buf2[] = {0x02,0x08,03};
    [self.client writeData:[NSData dataWithBytes:buf2 length:sizeof(buf2)] withTimeout:-1 tag:1000];
    NSLog(@"send heart beat");
//    uint8_t buf1[] = {0x03,0x02,0x08,03};
//    [self.client writeData:[NSData dataWithBytes:buf1 length:sizeof(buf1)] withTimeout:5 tag:1000];
   // NSLog(@"send Heart beat bytes %d",sizeof(buf) + sizeof(buf2));
}


@end
