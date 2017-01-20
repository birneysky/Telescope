//
//  TEAudioInfoView.h
//  Telescope
//
//  Created by zhangguang on 17/1/20.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TEAudioInfoView : UIView

//@property (nonatomic,readonly) UILabel* durationLabel;
//@property (nonatomic,)


/**
 发送者是不是自己
 */
@property (nonatomic,assign) BOOL senderisMe;

- (void)setDurationText:(NSString*)text;



@end
