//
//  TEMessage.m
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEMessage.h"

#import "TEMessage+CoreDataProperties.h"
#import "TEChatXMLReader.h"

@implementation TEMessage

@synthesize layout = _layout;
@synthesize chatMessage = _chatMessage;

- (TEBubbleCellInnerLayout*)layout
{
    if (!_layout) {
        _layout = [[TEBubbleCellInnerLayout alloc] initWithMessage:self.chatMessage];
    }
    return _layout;
}

- (TEChatMessage*)chatMessage
{
    if (!_chatMessage) {
        _chatMessage = [TEChatXMLReader messageForXmlString:self.content error:nil];
        _chatMessage.senderIsMe = self.senderIsMe;
        //_chatMessage.time = self.sendTime;
    }
    _chatMessage.time = self.sendTime;
    return _chatMessage;
}


- (void)reLayout
{
    _chatMessage = nil;
    _layout = nil;
    [self layout];
}


- (void)dealloc
{
    NSLog(@"♻️♻️♻️♻️ TEMessage ~ %@ ",self);
}

@end
