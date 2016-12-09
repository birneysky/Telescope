//
//  TEBubbleCellInnerLayout.m
//  Telescope
//
//  Created by zhangguang on 16/12/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEBubbleCellInnerLayout.h"
#import "TETextLayoutModel.h"
#import "TETextFrameParser.h"
#import "TEChatXMLReader.h"
#import "TEChatMessage.h"

#import "TEMessage+CoreDataProperties.h"





@interface TEBubbleCellInnerLayout ()

@property (nonatomic,strong) TETextLayoutModel* layoutModel;


@end

@implementation TEBubbleCellInnerLayout


#pragma mark - *** Api ***
- (instancetype)initWithMessage:(TEMessage*)message
{
    if (self = [super init]) {
        NSString* text = message.content;
        TEChatMessage* message = [TEChatXMLReader messageForXmlString:text error:nil];
        _layoutModel = [TETextFrameParser parseChatMessage:message];
        
        
        _avatarFrame = CGRectMake(Spacing,Spacing, AvatarWidth, AvatarHeight);
        
        CGFloat contextX = _avatarFrame.origin.x + _avatarFrame.size.width + Spacing;
        _contentFrame = CGRectMake(contextX, Spacing, _layoutModel.width + Spacing * 2, _layoutModel.height+ Spacing * 2);

    }
    return self;
}

- (CGFloat)cellHeight
{
    return _contentFrame.size.height + Spacing * 2  ;
}



@end
