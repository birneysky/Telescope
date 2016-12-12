//
//  TEMsgSubItem.h
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TETextLayoutModelProtocol.h"

typedef NS_ENUM(NSUInteger,TEMsgSubItemType){
    Unknown = 0,
    Text,
    Image,
    Link,
    Face,
    Audio
};


#define TETextElement    @"TTextChatItem"
#define TETextAttribute @"Text"

#define TELinkElement    @"TLinkTextChatItem"
#define TEURLAttribute @"URL"

#define TESysFaceElement @"TSysFaceChatItem"
#define TEFileNameAttribute @"FileName"

#define TEPictureElement @"TPictureChatItem"
#define TEFileExtAttribute @"FileExt"
#define TEUUIDAttribute @"GUID"
#define TEWidhtAttribute @"Width"
#define TEHeightAttribute @"Height"

#define TEChatElement @"TChatData"
#define TEAutoRelyAttribute @"IsAutoReply"
#define TEMessageIDAttribute @"MessageID"

#define TEChatItemElement @"ItemList"




/**
 理论上，一条消息是可以一个或者多个不同类型的子消息项
 它们通常是，文本，图片，语音，表情（跟图像是一回事）。语音类型只包含一个子消息项
 */
@interface TEMsgSubItem : NSObject

@property (nonatomic,assign) TEMsgSubItemType type;

- (instancetype)initWithType:(TEMsgSubItemType)type;

- (NSDictionary*) toDictionary;

@end


/**
 文本子消息项
 */
@interface TEMsgTextSubItem : TEMsgSubItem

@property (nonatomic,copy) NSString* textContent;

- (NSDictionary*) toDictionary;

@end

/**
 图片子消息项
 */
@interface TEMsgImageSubItem : TEMsgSubItem <TETextImageModel>

@property (copy, nonatomic) NSString * fileName;

@property (nonatomic,assign) NSUInteger position;

@property (nonatomic) CGRect imagePosition;

- (NSDictionary*) toDictionary;

@end


/**
 表情子消息项
 */
@interface TEExpresssionSubItem : TEMsgImageSubItem

@end

/**
 链接子消息项
 */
@interface TEMsgLinkSubItem : TEMsgSubItem <TETextLinkModel>

@property (copy, nonatomic) NSString * title;

@property (copy, nonatomic) NSString * url;

@property (assign, nonatomic) NSRange range;

- (NSDictionary*) toDictionary;

@end


/**
 语音文件子消息项
 */
@interface TEMSgAudioSubItem : TEMsgSubItem

@end

