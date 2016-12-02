//
//  TEChatSessionCell.h
//  Telescope
//
//  Created by zhangguang on 16/12/1.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEChatSessionCell : UITableViewCell


/**
 设置用户名

 @param name 用户昵称
 */
- (void)setUserName:(NSString*)name;


/**
 设置消息概览

 @param message 消息字符串
 */
- (void)setMessageOverView:(NSString*)message;


/**
 设置消息日期

 @param date 时间参数
 */
- (void)setMessageDate:(NSDate*)date;

@end
