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
