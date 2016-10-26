//
//  TEPacketDisPatcher.m
//  Telescope
//
//  Created by zhangguang on 16/10/10.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEPacketDisPatcher.h"
#import <Foundation/Foundation.h>
#import "TENetworkOperation.h"
#import <ProtocolBuffers/ProtocolBuffers.h>

@implementation TEPacketDisPatcher


- (void)didParsePacket:(V2PPacket *)packet
{
    switch (packet.packetType) {
        case V2PPacket_type_Iq:
            //NSLog(@"V2PPacket_type_Iq");
            [self handleSignalling:packet];
            break;
        case V2PPacket_type_Msg:
            NSLog(@"V2PPacket_type_Msg");
            break;
        case V2PPacket_type_Beat:
            [self handleHeartBeat:packet];
            //NSLog(@"V2PPacket_type_Beat");
            break;
        default:
            NSLog(@"V2PPacket_type_unknown");
            break;
    }
}


//long long pointValue = strtoll(packetId.UTF8String, NULL, 16);//(void*)[packetId longLongValue];
//void* operationP = (void*)[packetId longLongValue];
//
//NSObject* object = (__bridge NSObject *)(operationP);
//
//
//if ([object isMemberOfClass:[TENetworkOperation class]]) {
//    TENetworkOperation* op = (TENetworkOperation*)object;
//    [op operationSucceeded:nil];
//}

- (void)handleSignalling:(V2PPacket*)packet{
    NSString* packetId = packet.id_p;
    if (packetId.length > 0) {
        long long pointValue = strtoll(packetId.UTF8String, NULL, 16);
        if (0 != pointValue) {
            void* operationP = (void*)pointValue;
            NSObject* object = (__bridge NSObject *)(operationP);
            if ([object isMemberOfClass:[TENetworkOperation class]]) {
                TENetworkOperation* op = (TENetworkOperation*)object;
                [op operationSucceeded:packet];
            }
        }
        else{

        }
    }
    else{
        NSLog(@"‼️‼️‼️‼️ packetId is null");
    }
}

- (void)handleHeartBeat:(V2PPacket*)packet{
    NSString* packetId = packet.id_p;
    NSLog(@"❤️❤️❤️❤️ %@",packetId);
}

@end
