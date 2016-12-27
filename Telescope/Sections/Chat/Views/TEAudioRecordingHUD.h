//
//  TEAudioRecordingHUD.h
//  Telescope
//
//  Created by zhangguang on 16/12/27.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TEAudioRecordingState){
    TEAudioRecordingStateRecording,
    TEAudioRecordingStateMyBeCancel,
    TEAudioRecordingStateError
};


@interface TEAudioRecordingHUD : UIView

@property (nonatomic,assign) TEAudioRecordingState state;

- (void)setAudioVolume:(NSInteger)vol;



@end
