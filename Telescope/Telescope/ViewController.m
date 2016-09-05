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
//    dispatch_queue_t queue = dispatch_queue_create("com.telescope.network", DISPATCH_QUEUE_SERIAL);
//    self.client = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
//    self.client.delegate = self;
//    NSError* error;
//    [self.client connectToHost:@"123.57.20.30" onPort:9997 error:&error];
    NSLog(@"%@",data);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
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
    //[self.client write:[NSData dataWithBytes:buf length:3]];
    //[self.client write:[NSData dataWithBytes:bufLogin length:54]];
    //[self.client.socket readDataWithTimeout:100 tag:1000];
    [self.client readDataWithTimeout:100 tag:1000];
    //for (int i = 0; i < 10000; i++) {
        [self.client writeData:[NSData dataWithBytes:bufLogin length:sizeof(bufLogin)] withTimeout:100 tag:1000];
    //}
    NSLog(@"done");
   
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"%@,length %ld",data,(long)data.length);
    NSString* test = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"string %@",test);
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
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
