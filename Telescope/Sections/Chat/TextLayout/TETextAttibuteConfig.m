//
//  TETextAttibuteConfig.m
//  Telescope
//
//  Created by zhangguang on 16/12/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TETextAttibuteConfig.h"

@implementation TETextAttibuteConfig

- (id)init {
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = TERGB(108, 108, 108);
    }
    return self;
}

@end
