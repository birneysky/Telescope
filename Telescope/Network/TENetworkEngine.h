//
//  NettyNetWorkEngine.h
//  Telescope
//
//  Created by zhangguang on 16/9/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TENetworkEngine : NSObject

- (void) sendData:(NSData *)data;

- (BOOL)connectToHost:(NSString*)host onPort:(uint16_t)port error:(NSError **)errPtr;

- (void)disconnect;

@end
