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

@property (nonatomic,strong) TEMSgAudioSubItem* audioItem;

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
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_audioInfoView addGestureRecognizer:tapGesture];
    }
    return _audioInfoView;
}

#pragma mark - *** Override ***
- (void)setMessage:(TEMessage *)message
{
    [super setMessage:message];
    self.audioInfoView.senderisMe = message.senderIsMe;
    self.audioInfoView.frame = message.layout.contentFrame;
    
    TEMSgAudioSubItem* audioItem = (TEMSgAudioSubItem*)message.chatMessage.msgItemList.firstObject;
    self.audioItem = audioItem;
    NSMutableAttributedString* basicAttributeString =
        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld's ",audioItem.duration]
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],
                                                            NSForegroundColorAttributeName: message.senderIsMe ? [UIColor whiteColor] : [UIColor grayColor]}];
    if (!message.read) {
        [basicAttributeString appendAttributedString:[[NSAttributedString alloc] initWithString:@" ●" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor redColor]}]];
    }
//    [self.audioInfoView setDurationText:[NSString stringWithFormat:@"%ld's ",audioItem.duration]];
    [self.audioInfoView setDurationAttributeText:[basicAttributeString copy]];
    if(!self.audioInfoView.superview){
        [self.contentView addSubview:self.audioInfoView];
    }
}


#pragma mark - *** Gesture Selector ***
- (void)tap:(UITapGestureRecognizer*)tapRecognizer
{
    NSLog(@"‼️‼️‼️‼️");
    
    if ([self.playDelegate respondsToSelector:@selector(didSelectAudioCell:fileName:)]) {
        [self.playDelegate didSelectAudioCell:self fileName:self.audioItem.filePath];
    }
    
}


- (void)startAnimating
{
    [self.audioInfoView startAnimating];
}
- (void)stopAnimating
{
    [self.audioInfoView stopAnimating];
}



@end
