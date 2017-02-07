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
        _type = type;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        _type = Unknown;
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
        case Audio:
            [dictory setObject:[NSMutableDictionary dictionary] forKey:TEAudioElement];
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
    [sub setObject:@(self.frame.size.width)
            forKey:[NSString stringWithFormat:@"_%@",TEWidhtAttribute]];
    [sub setObject:@(self.frame.size.height)
            forKey:[NSString stringWithFormat:@"_%@",TEHeightAttribute]];
    [sub setObject:self.fileName forKey:[NSString stringWithFormat:@"_%@",TEUUIDAttribute]];
    [sub setObject:self.fileExt forKey:[NSString stringWithFormat:@"_%@", TEFileExtAttribute]];
    return rootDic;
}

- (NSString*)filePath
{
    NSString* fileThumbnailName = [NSString stringWithFormat:@"%@_%@%@",self.fileName,@"thumbnail",self.fileExt];
    //NSString* fileThumbnailName = [NSString stringWithFormat:@"%@%@",self.fileName,self.fileExt];
    return [self.path stringByAppendingPathComponent:fileThumbnailName];
}

- (TEPlaceholderType)holderType
{
    return PlaceholderImageType;
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

- (NSString*)filePath
{
    return [self.path stringByAppendingPathComponent:self.fileName];
}

- (TEPlaceholderType)holderType
{
    return PlaceholderImageType;
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


@implementation TEMSgAudioSubItem

- (NSDictionary*) toDictionary
{
    NSDictionary* rootDic = [super toDictionary];
    NSMutableDictionary* sub = [rootDic objectForKey:TEAudioElement];
    [sub setObject:self.fileName
            forKey:[NSString stringWithFormat:@"_%@",TEFileIDAttribute]];
    [sub setObject:[NSString stringWithFormat:@"%ld",(long)self.duration]
            forKey:[NSString stringWithFormat:@"_%@",TESecondsAttribute]];
    [sub setObject:self.fileExt
            forKey:[NSString stringWithFormat:@"_%@",TEFileExtAttribute]];
    return rootDic;
}

- (TEPlaceholderType)holderType
{
    return PlaceholderAudioType;
}

@end
