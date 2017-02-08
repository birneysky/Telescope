//
//  TEAudioInfoView.m
//  Telescope
//
//  Created by zhangguang on 17/1/20.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import "TEAudioInfoView.h"



@implementation TEAudioInfoView
{
    UILabel* _durationLabel;
    UIImageView* _voiceIconImageView;
    CGSize _textSize;
}


- (instancetype) init
{
    if (self = [super init]) {
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 21)];
        _durationLabel.font = [UIFont systemFontOfSize:12.0f];
        _voiceIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 17)];
        [self addSubview:_durationLabel];
        [self addSubview:_voiceIconImageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    CGSize selfSize = self.bounds.size;
    CGSize iconSize = _voiceIconImageView.bounds.size;
    if (self.senderisMe) {
        _durationLabel.frame = CGRectMake(8, (selfSize.height - _textSize.height) / 2.0f, _textSize.width, _textSize.height);
        _voiceIconImageView.frame = CGRectMake(selfSize.width - iconSize.width - 10, (selfSize.height - iconSize.height) / 2.0f, iconSize.width, iconSize.height);
    }
    else{
        _voiceIconImageView.frame = CGRectMake(8, (selfSize.height - iconSize.height ) / 2.0f, iconSize.width, iconSize.height);
        _durationLabel.frame = CGRectMake(selfSize.width - _textSize.width - 8, (selfSize.height - _textSize.height) / 2, _textSize.width, _textSize.height);
    }
}


- (void)setDurationText:(NSString*)text
{
    _textSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    _durationLabel.text = text;
}

- (void)setSenderisMe:(BOOL)senderisMe
{
    _senderisMe = senderisMe;
    if (senderisMe) {
        _voiceIconImageView.image = [UIImage imageNamed:@"te_voice_animation_white3"];
        _voiceIconImageView.animationImages = @[[UIImage imageNamed:@"te_voice_animation_white3"],
                                                [UIImage imageNamed:@"te_voice_animation_white2"],
                                                [UIImage imageNamed:@"te_voice_animation_white1"]];
        _durationLabel.textColor = [UIColor whiteColor];
    }
    else{
        _voiceIconImageView.image = [UIImage imageNamed:@"te_voice_animation_gary3"];
        _voiceIconImageView.animationImages = @[[UIImage imageNamed:@"te_voice_animation_gary3"],
                                                [UIImage imageNamed:@"te_voice_animation_gary2"],
                                                [UIImage imageNamed:@"te_voice_animation_gary1"]];
    }
    
    _voiceIconImageView.animationDuration = 0.5;
}

- (void)startAnimating
{
    [_voiceIconImageView startAnimating];
}
- (void)stopAnimating
{
    [_voiceIconImageView  stopAnimating];
}

@end
