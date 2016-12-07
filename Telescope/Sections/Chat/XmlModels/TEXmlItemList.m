//
//  TEXmlItemList.m
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEXmlItemList.h"



@interface TEXmlItemList ()

@property (nonatomic,strong) NSMutableArray<TEMsgSubItem*>* itemArray;

@end

@implementation TEXmlItemList

- (instancetype)initWithArray:(NSArray<NSDictionary*>*)array
{
    if (self = [super init]) {
        
    }
    return self;
}


#pragma mark - *** Helper ***
- (void)configItemArray:(NSArray<NSDictionary*>*)array{
    [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj objectForKey:@"TTextChatItem"]) {
            
        }

        
    }];
}

#pragma mark - *** Properties ***
- (NSMutableArray<TEMsgSubItem*>*)itemArray
{
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _itemArray;
}

#pragma mark - *** override ***

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    /*
     * 由于xml中定义了很多移动端用不到的xml,所以解析有用的信息即可
     */
    if ([key isEqualToString:@"TTextChatItem"]) {
        
    }
    else if ([key isEqualToString:@"TLinkTextChatItem"]){
        
    }
    NSLog(@"Undefine Key %@,value = %@",key,value);

}


#pragma mark *** Api ***
- (NSArray<TEMsgSubItem*>*)items
{
    return [_itemArray copy];
}
@end
