//
//  TENetworkKit.h
//  Telescope
//
//  Created by zhangguang on 16/10/10.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TENetworkKit : NSObject

+ (instancetype)defaultNetKit;


- (void) loginWithAccountNum:(NSString*)anum password:(NSString*)pwd;

@end
