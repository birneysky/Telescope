//
//  TEBubbleAudioCell.m
//  Telescope
//
//  Created by zhangguang on 17/1/20.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import "TEBubbleAudioCell.h"
#import "TEAudioInfoView.h"
#import "TEMessage+CoreDataProperties.h"


@interface TEBubbleAudioCell ()

@property (nonatomic,strong) TEAudioInfoView* audioInfoView;

@end

@implementation TEBubbleAudioCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

#pragma mark - *** Properties ***

- (TEAudioInfoView*)audioInfoView
{
    if (!_audioInfoView) {
        _audioInfoView = [[TEAudioInfoView alloc] init];
    }
    return _audioInfoView;
}

#pragma mark - *** ***
- (void)setMessage:(TEMessage *)message
{
    [super setMessage:message];
    self.audioInfoView.senderisMe = message.senderIsMe;
    self.audioInfoView.frame = message.layout.contentFrame;
    TEMSgAudioSubItem* audioItem = (TEMSgAudioSubItem*)message.chatMessage.msgItemList.firstObject;
    [self.audioInfoView setDurationText:[NSString stringWithFormat:@"%ld's",audioItem.duration]];
    
    if(!self.audioInfoView.superview){
        [self.contentView addSubview:self.audioInfoView];
    }
}


@end
