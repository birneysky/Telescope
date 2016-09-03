//
//  ViewController.m
//  Telescope
//
//  Created by zhangguang on 16/9/2.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong)  DFNettyCommonClient* client;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.client = [[DFNettyCommonClient alloc] init];
    [self.client connect:@"123.57.20.30" port:9997];
    self.client.socket.delegate = self;
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
    [self.client write:[NSData dataWithBytes:bufLogin length:54]];
    [self.client.socket readDataWithTimeout:100 tag:1000];
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


@end
