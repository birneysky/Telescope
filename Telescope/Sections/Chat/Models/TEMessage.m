//
//  TEMessage.m
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEMessage.h"
#import "TETextFrameParser.h"
#import "TEChatXMLReader.h"
#import "TEMessage+CoreDataProperties.h"

@implementation TEMessage

@synthesize layoutModel = _layoutModel;

- (TETextLayoutModel*)layoutModel
{
    if (!_layoutModel) {
        NSLog(@"%@",self.content);
        TEChatMessage* message = [TEChatXMLReader messageForXmlString:self.content error:nil];
        _layoutModel = [TETextFrameParser parseChatMessage:message];
    }
    return _layoutModel;
}



- (void)dealloc
{
    NSLog(@"♻️♻️♻️♻️ TEMessage ~ %@ ",self);
}

@end
