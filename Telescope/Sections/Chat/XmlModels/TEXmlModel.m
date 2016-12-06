//
//  TEXmlModel.m
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEXmlModel.h"

@implementation TEXmlModel

- (instancetype) initWithDictionary:(NSDictionary*)xmlDic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:xmlDic];
    }
    return self;
}

@end
