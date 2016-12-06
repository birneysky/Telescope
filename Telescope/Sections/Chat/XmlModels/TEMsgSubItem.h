//
//  TEMsgSubItem.h
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,TEMsgSubItemType){
    Text          = 0,
    Image,
    Link,
    Face
};


@interface TEMsgSubItem : NSObject

@property (nonatomic,assign) TEMsgSubItemType type;

@end


@interface TEMsgTextSubItem : TEMsgSubItem

@property (nonatomic,copy) NSString* textContent;

@end

@interface TEMsgImageSubItem : TEMsgSubItem

@property (strong, nonatomic) NSString * name;

@property (nonatomic) int position;

@property (nonatomic) CGRect imagePosition;

@end

@interface TEMsgLinkSubItem : TEMsgSubItem

//@property (strong, nonatomic) NSString * title;

@property (strong, nonatomic) NSString * url;

@property (assign, nonatomic) NSRange range;

@end

