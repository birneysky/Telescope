//
//  TEXmlChatData.m
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEXmlChatData.h"

@implementation TEXmlChatData

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"ItemList"]){
        self.msgItemList = [[TEXmlItemList alloc] initWithDictionary:value];
    }
    else{
       NSLog(@"Undefine Key %@,value = %@",key,value); 
    }
    
    
}
@end
