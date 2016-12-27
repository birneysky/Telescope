//
//  TEAudioRecordingHUD.m
//  Telescope
//
//  Created by zhangguang on 16/12/27.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEAudioRecordingHUD.h"

@interface TEAudioRecordingHUD ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *audioRecordingVolumImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusIconImageView;
@property (weak, nonatomic) IBOutlet UIView *volumeView;
@end

@implementation TEAudioRecordingHUD

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setAudioVolume:(NSInteger)vol
{
    if (vol < 3) {
        [self.audioRecordingVolumImageView setImage:nil];
    }
    else if (vol < 6)
    {
        [self.audioRecordingVolumImageView setImage:[UIImage imageNamed:@"chat_audioRecord_volumn1.png"]];
    }
    else if (vol < 9)
    {
        [self.audioRecordingVolumImageView setImage:[UIImage imageNamed:@"chat_audioRecord_volumn2.png"]];
    }
    else if (vol < 12)
    {
        [self.audioRecordingVolumImageView setImage:[UIImage imageNamed:@"chat_audioRecord_volumn3.png"]];
    }
    else if (vol < 15)
    {
        [self.audioRecordingVolumImageView setImage:[UIImage imageNamed:@"chat_audioRecord_volumn4.png"]];
    }
    else
    {
        [self.audioRecordingVolumImageView setImage:[UIImage imageNamed:@"chat_audioRecord_volumn4.png"]];
    }
}


- (void)setState:(TEAudioRecordingState)state
{
    switch (state) {
        case TEAudioRecordingStateRecording:
            self.volumeView.hidden = NO;
            self.statusIconImageView.hidden = YES;
            self.statusLabel.text = @"向上滑动，取消发送";
            break;
        case TEAudioRecordingStateMyBeCancel:
            self.volumeView.hidden = YES;
            self.statusIconImageView.hidden = NO;
            self.statusIconImageView.image = [UIImage imageNamed:@"te_audioRecord_cancel"];
            break;
        case TEAudioRecordingStateError:
            self.volumeView.hidden = YES;
            self.statusIconImageView.hidden = NO;
            self.statusIconImageView.image = [UIImage imageNamed:@"te_exclamation_mark"];
            self.statusLabel.text = @"录制失败";
            break;
        default:
            break;
    }
}


@end
