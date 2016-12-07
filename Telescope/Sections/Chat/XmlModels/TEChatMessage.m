//
//  TEXmlChatData.m
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEChatMessage.h"
#import "XMLDictionary.h"

@interface TEChatMessage ()

@property(nonatomic,strong) NSMutableArray<TEMsgSubItem*>* messageSubItems;

@end

@implementation TEChatMessage

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

@end
