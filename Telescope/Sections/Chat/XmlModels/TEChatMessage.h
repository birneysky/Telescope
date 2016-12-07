//
//  TEXmlChatData.h
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEMsgSubItem.h"

@interface TEChatMessage : NSObject

@property (nonatomic,assign) BOOL isAutoReply;
@property (nonatomic,readonly) NSArray<TEMsgSubItem*>* msgItemList;
@property (nonatomic,copy) NSString* messageID;

- (void)addItem:(TEMsgSubItem*) item;
- (void)removeItem:(TEMsgSubItem*) item;

//- (NSDictionary*)toDictionary;

- (NSString*)xmlString;

@end
