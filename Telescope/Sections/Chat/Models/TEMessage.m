//
//  TEMessage.m
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEMessage.h"
#import "NSDate+Utils.h"
#import "TEMessage+CoreDataProperties.h"

@implementation TEMessage

@synthesize layout = _layout;
@synthesize timeLabelString = _timeLabelString;

- (TEBubbleCellInnerLayout*)layout
{
    if (!_layout) {
        _layout = [[TEBubbleCellInnerLayout alloc] initWithMessage:self];
    }
    return _layout;
}

- (NSString*)timeLabelString
{
    if (!_timeLabelString) {
        NSString *dateStr;  //年月日
        NSString *period;   //时间段
        NSString *hour;     //时
        if ([self.sendTime year]==[[NSDate date] year]) {

            NSInteger days = [NSDate daysOffsetBetweenStartDate:self.sendTime endDate:[NSDate date]];
            if (days <= 2) {
                dateStr = [self.sendTime stringYearMonthDayCompareToday];
            }else{
                dateStr = [self.sendTime stringMonthDay];
            }
        }else{
            dateStr = [self.sendTime stringYearMonthDay];
        }
        
        
        if ([self.sendTime hour]>=5 && [self.sendTime hour]<12) {
            period = @"AM";
            hour = [NSString stringWithFormat:@"%02d",(int)[self.sendTime hour]];
        }else if ([self.sendTime hour]>=12 && [self.sendTime hour]<=18){
            period = @"PM";
            hour = [NSString stringWithFormat:@"%02d",(int)[self.sendTime hour]-12];
        }else if ([self.sendTime hour]>18 && [self.sendTime hour]<=23){
            period = @"Night";
            hour = [NSString stringWithFormat:@"%02d",(int)[self.sendTime hour]-12];
        }else{
            period = @"Dawn";
            hour = [NSString stringWithFormat:@"%02d",(int)[self.sendTime hour]];
        }
        _timeLabelString = [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[self.sendTime minute]];;
    }
    return _timeLabelString;
}

- (void)dealloc
{
    NSLog(@"♻️♻️♻️♻️ TEMessage ~ %@ ",self);
}

@end
