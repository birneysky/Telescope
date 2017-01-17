//
//  TEXmlChatData.h
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEMsgSubItem.h"

typedef NS_ENUM(NSInteger,TEChatMessageType){
    TEChatMessageTypeText,
    TEChatMessageTypeRichText,
    TEChatMessageTypeAudio,
    TEChatMessageTypeDocument
};

@interface TEChatMessage : NSObject

@property (nonatomic,assign) BOOL isAutoReply;
@property (nonatomic,readonly) NSArray<TEMsgSubItem*>* msgItemList;
@property (nonatomic,copy) NSString* messageID;
@property (nonatomic,strong) NSDate* time;
@property (nonatomic,assign) BOOL senderIsMe;
@property (nonatomic,assign) TEChatMessageType type;


- (void)addItem:(TEMsgSubItem*) item;
- (void)removeItem:(TEMsgSubItem*) item;

//- (NSDictionary*)toDictionary;

- (NSString*)xmlString;

- (NSString*)overviewText;

- (NSString*)timeLabelString;

@end

@interface TEChatMessage ()

+ (TEChatMessage*)buildTextMessage;

+ (TEChatMessage*)buildAudioMessage;

+ (TEChatMessage*)buildDocumentMessage;

@end
