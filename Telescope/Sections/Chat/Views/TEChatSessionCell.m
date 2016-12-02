//
//  TEChatSessionCell.m
//  Telescope
//
//  Created by zhangguang on 16/12/1.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEChatSessionCell.h"

@interface TEChatSessionCell ()


@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation TEChatSessionCell

- (void)setUserName:(NSString *)name
{
    self.textLabel.text = name;
}

- (void)setMessageOverView:(NSString *)message
{
    self.detailTextLabel.text = message;
}

- (void)setMessageDate:(NSDate *)date
{
    NSDateFormatter*  dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSString* dateString = [dateFormatter stringFromDate:date];
    self.dateLabel.text = dateString;
}

@end
