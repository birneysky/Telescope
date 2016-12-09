//
//  TEMessage.m
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEMessage.h"

@implementation TEMessage

@synthesize layout = _layout;

- (TEBubbleCellInnerLayout*)layout
{
    if (!_layout) {
        _layout = [[TEBubbleCellInnerLayout alloc] initWithMessage:self];
    }
    return _layout;
}

- (void)dealloc
{
    //NSLog(@"♻️♻️♻️♻️ TEMessage ~ %@ ",self);
}

@end
