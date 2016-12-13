//
//  ChatExtraPanel.h
//  WeChat
//
//  Created by zhangguang on 16/3/21.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

//@[@"照片",@"拍摄",@"小视屏",@"视频聊天",@"红包",@"转账",@"位置",@"收藏",@"个人名片",@"语音输入"];
typedef NS_ENUM(NSInteger,TEMorePanelBizType){
    Photo,
    Shot,
    SmallVideo,
    VideoChat
};


@protocol TEChatMorePanelDelegate <NSObject>

- (void)didSelectItemOfType:(TEMorePanelBizType)type;

@end

@interface TEChatMorePanel : UIView

@property (nonatomic,weak) id<TEChatMorePanelDelegate> delegate;

@end
