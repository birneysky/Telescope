//
//  TEVideoPlayer.h
//  Telescope
//
//  Created by zhangguang on 16/11/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 rtmp 流播放器
 */
@interface TEVideoPlayer : UIView


- (void)startRtmpPlay:(NSString*)url;

- (void)stopRtmpPlay;

@end
