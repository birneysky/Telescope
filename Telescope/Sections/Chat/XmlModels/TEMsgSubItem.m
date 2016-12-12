//
//  TEMsgSubItem.m
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEMsgSubItem.h"

@implementation TEMsgSubItem

- (instancetype)initWithType:(TEMsgSubItemType)type
{
    if (self = [self init]) {
        self.type = type;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.type = Unknown;
    }
    return self;
}

- (NSDictionary*) toDictionary
{
    NSMutableDictionary* dictory = [[NSMutableDictionary alloc] init];
    switch (self.type) {
        case Text:
            [dictory setObject:[NSMutableDictionary dictionary] forKey:TETextElement];
            break;
        case Link:
            [dictory setObject:[NSMutableDictionary dictionary] forKey:TELinkElement];
            break;
        case Image:
            [dictory setObject:[NSMutableDictionary dictionary] forKey:TEPictureElement];
            break;
        case Face:
            [dictory setObject:[NSMutableDictionary dictionary] forKey:TESysFaceElement];
            break;
        default:
            dictory = nil;
            break;
    }
    return [dictory copy];
}

@end

@implementation TEMsgTextSubItem

- (NSDictionary*) toDictionary
{
    NSDictionary* rootDic = [super toDictionary];
    NSMutableDictionary* sub = [rootDic objectForKey:TETextElement];
    [sub setObject:self.textContent
            forKey:[NSString stringWithFormat:@"_%@",TETextAttribute]];
    return rootDic;
}

@end

@implementation TEMsgImageSubItem

- (NSDictionary*) toDictionary
{
    NSDictionary* rootDic = [super toDictionary];
    NSMutableDictionary* sub = [rootDic objectForKey:TEPictureElement];
    [sub setObject:@(self.imagePosition.size.width)
            forKey:[NSString stringWithFormat:@"_%@",TEWidhtAttribute]];
    [sub setObject:@(self.imagePosition.size.height)
            forKey:[NSString stringWithFormat:@"_%@",TEHeightAttribute]];
    [sub setObject:self.fileName forKey:[NSString stringWithFormat:@"_%@",TEUUIDAttribute]];
    return rootDic;
}

@end

@implementation TEExpresssionSubItem

- (NSDictionary*) toDictionary
{
    NSDictionary* rootDic = [super toDictionary];
    NSMutableDictionary* sub = [rootDic objectForKey:TESysFaceElement];
    [sub setObject:self.fileName
            forKey:[NSString stringWithFormat:@"_%@",TEFileNameAttribute]];
    return rootDic;
}

@end

@implementation TEMsgLinkSubItem

- (NSDictionary*) toDictionary
{
    NSDictionary* rootDic = [super toDictionary];
    NSMutableDictionary* sub = [rootDic objectForKey:TELinkElement];
    [sub setObject:self.url
            forKey:[NSString stringWithFormat:@"_%@",TEURLAttribute]];
    return rootDic;
}


@end
