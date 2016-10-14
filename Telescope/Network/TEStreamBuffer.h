//
//  TEStreamBuffer.h
//  Telescope
//
//  Created by Showers on 16/9/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

/*
 *   处理数据，解析数据
 */


#import <Foundation/Foundation.h>
#import <ProtocolBuffers/ProtocolBuffers.h>


@protocol TEStreamBufferDegate <NSObject>

- (void)didParsePacket:(V2PPacket*)packet;

@end


@interface TEStreamBuffer : NSObject

@property (nonatomic,weak) id<TEStreamBufferDegate> delegate;

- (void) appendData:(NSData*)data;

@end
