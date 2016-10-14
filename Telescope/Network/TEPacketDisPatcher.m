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

@implementation TEPacketDisPatcher


- (void)didParsePacket:(V2PPacket *)packet
{

    NSString* packetId = packet.id_p;
    void* operationP = (void*)[packetId longLongValue];
    
    NSObject* object = (__bridge NSObject *)(operationP);
    
    
    if ([object isMemberOfClass:[TENetworkOperation class]]) {
        
    }
    
    
    switch (packet.packetType) {
        case V2PPacket_type_Iq:
            NSLog(@"V2PPacket_type_Iq");
            break;
        case V2PPacket_type_Msg:
            NSLog(@"V2PPacket_type_Msg");
            break;
        case V2PPacket_type_Beat:
            NSLog(@"V2PPacket_type_Beat");
            break;
        default:
            NSLog(@"V2PPacket_type_unknown");
            break;
    }
}


@end
