//
//  TEMsgSubItem.h
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,TEMsgSubItemType){
    Unknown = 0,
    Text,
    Image,
    Link,
    Face
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


@interface TEMsgSubItem : NSObject

@property (nonatomic,assign) TEMsgSubItemType type;

- (instancetype)initWithType:(TEMsgSubItemType)type;

- (NSDictionary*) toDictionary;

@end


@interface TEMsgTextSubItem : TEMsgSubItem

@property (nonatomic,copy) NSString* textContent;

- (NSDictionary*) toDictionary;

@end

@interface TEMsgImageSubItem : TEMsgSubItem

@property (strong, nonatomic) NSString * fileName;

@property (nonatomic) int position;

@property (nonatomic) CGRect imagePosition;

- (NSDictionary*) toDictionary;

@end

@interface TEMsgLinkSubItem : TEMsgSubItem

//@property (strong, nonatomic) NSString * title;

@property (strong, nonatomic) NSString * url;

@property (assign, nonatomic) NSRange range;

- (NSDictionary*) toDictionary;

@end

