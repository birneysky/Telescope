//
//  TELiveShowInfo.h
//  Telescope
//
//  Created by zhangguang on 16/11/2.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 直播信息类
 */
@interface TELiveShowInfo : NSObject


/**
 直播id
 */
@property (nonatomic,assign) NSInteger liveId;


/**
 直播经纬度
 */
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;


/**
 直播观看总人数
 */
@property (nonatomic,assign) NSInteger totalNumberOfPeopleWatchingLive;


/**
 直播播放地址
 */
@property (nonatomic,copy) NSString* liveStreamingAddress;

@end
