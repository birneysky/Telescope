//
//  TETextLayoutProtocol.h
//  Telescope
//
//  Created by zhangguang on 16/12/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "TEChatMessage.h"


@protocol TETextLinkModel <NSObject>

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * url;
@property (assign, nonatomic) NSRange range;

@end


@protocol TETextImageModel <NSObject>

@property (strong, nonatomic) NSString * name;
@property (nonatomic) int position;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;

@end


@interface TETextLayoutModel: NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSArray<id<TETextImageModel>>* imageArray;
@property (strong, nonatomic) NSArray<id<TETextLinkModel>>* linkArray;
@property (strong, nonatomic) NSAttributedString *content;

@end


