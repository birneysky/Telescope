//
//  TEBubbleCellInnerLayout.h
//  Telescope
//
//  Created by zhangguang on 16/12/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>


#define AvatarWidth 44
#define AvatarHeight 44

#define Spacing 8


@class TEMessage;
@class TETextLayoutModel;



@interface TEBubbleCellInnerLayout : NSObject


/**
 头像位置
 */
@property (nonatomic, assign, readonly) CGRect avatarFrame;

/**
 时间标签位置
 */
@property (nonatomic, assign, readonly) CGRect timeLabelFrame;

/**
 消息内容位置
 */
@property (nonatomic, assign, readonly) CGRect contentFrame;

/**
 cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;


/**
 排版模型
 */
@property (nonatomic, strong, readonly)TETextLayoutModel* layoutModel;


- (instancetype)initWithMessage:(TEMessage*)message;



@end
