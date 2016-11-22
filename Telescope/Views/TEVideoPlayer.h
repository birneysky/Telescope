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


/**
 是否自动切换至下一个
 */
@property (nonatomic,assign) BOOL automaticallySwitchToTheNext;

/**
 开始播放
 
 @param url rtmp 播放地址
 */
- (void)startRtmpPlayWithUrl:(NSString*)url;



/**
 停止播放
 */
- (void)stopRtmpPlay;

- (void)clear;

@end
