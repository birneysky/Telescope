//
//  TEXmlChatData.m
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEChatMessage.h"
#import "XMLDictionary.h"
#import "TEExpressionNamesManager.h"
#import "NSDate+Utils.h"

@interface TEChatMessage ()

@property(nonatomic,strong) NSMutableArray<TEMsgSubItem*>* messageSubItems;

@end

@implementation TEChatMessage
{
    NSString* _timeLabelString;
}
- (NSMutableArray<TEMsgSubItem*>*)messageSubItems
{
    if (!_messageSubItems) {
        _messageSubItems = [[NSMutableArray alloc] init];
    }
    return _messageSubItems;
}

- (void)addItem:(TEMsgSubItem*) item
{
    [self.messageSubItems addObject:item];
}

- (void)removeItem:(TEMsgSubItem*) item
{
    [self.messageSubItems removeObject:item];
}

- (NSArray<TEMsgSubItem*>*) msgItemList
{
    return [self.messageSubItems copy];
}

#pragma mark - *** Helper ***

- (NSDictionary*)toDictionary
{
    NSMutableDictionary* rootDic = [[NSMutableDictionary alloc] init];
    NSMutableArray* items = [[NSMutableArray alloc] init];
    [self.messageSubItems enumerateObjectsUsingBlock:^(TEMsgSubItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [items addObject:[obj toDictionary]];
    }];
    
    [rootDic setObject:[items copy] forKey:TEChatItemElement];
    [rootDic setObject:self.messageID forKey:[NSString stringWithFormat:@"_%@",TEMessageIDAttribute]];
    [rootDic setObject: self.isAutoReply ? @"True" : @"False" forKey:[NSString stringWithFormat:@"_%@",TEAutoRelyAttribute]];
    [rootDic setObject:items forKey:TEChatItemElement];
    return @{TEChatElement:[rootDic copy]};
}

- (NSString*)xmlString
{
    NSDictionary* dic = [self toDictionary];
    return [dic XMLString];
}

- (NSString*)overviewText
{
    NSMutableString* text = [[NSMutableString alloc] init];
    [self.messageSubItems enumerateObjectsUsingBlock:^(TEMsgSubItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(Text == obj.type){
            TEMsgTextSubItem* textItem = (TEMsgTextSubItem*)obj;
            [text appendString:textItem.textContent];
        }
        else if (Link == obj.type){
            TEMsgLinkSubItem* linkItem = (TEMsgLinkSubItem*)obj;
            [text appendString:linkItem.url];
        }
        else if (Face == obj.type){
            TEExpresssionSubItem* expressionItem = (TEExpresssionSubItem*)obj;
            NSString* faceName = [NSString stringWithFormat:@"[%@]",[[TEExpressionNamesManager defaultManager] nameAtIndex:[expressionItem.fileName integerValue]]];
            [text appendString:faceName];
        }
        else if (Image == obj.type){
            [text appendString:@"[图片]"];
        }
        else if(Audio == obj.type){
            [text appendString:@"[语音]"];
        }
    }];
    return [text copy];
}


- (NSString*)timeLabelString
{
    if (!_timeLabelString) {
        NSString *dateStr;  //年月日
        NSString *period;   //时间段
        NSString *hour;     //时
        if ([self.time year]==[[NSDate date] year]) {
            
            NSInteger days = [NSDate daysOffsetBetweenStartDate:self.time endDate:[NSDate date]];
            if (days <= 2) {
                dateStr = [self.time stringYearMonthDayCompareToday];
            }else{
                dateStr = [self.time stringMonthDay];
            }
        }else{
            dateStr = [self.time stringYearMonthDay];
        }
        
        
        if ([self.time hour]>=5 && [self.time hour]<12) {
            period = @"AM";
            hour = [NSString stringWithFormat:@"%02d",(int)[self.time hour]];
        }else if ([self.time hour]>=12 && [self.time hour]<=18){
            period = @"PM";
            hour = [NSString stringWithFormat:@"%02d",(int)[self.time hour]-12];
        }else if ([self.time hour]>18 && [self.time hour]<=23){
            period = @"Night";
            hour = [NSString stringWithFormat:@"%02d",(int)[self.time hour]-12];
        }else{
            period = @"Dawn";
            hour = [NSString stringWithFormat:@"%02d",(int)[self.time hour]];
        }
        _timeLabelString = [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[self.time minute]];;
    }
    return _timeLabelString;
}

@end
