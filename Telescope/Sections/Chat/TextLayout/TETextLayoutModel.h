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
#import "TETextLayoutModelProtocol.h"


@interface TETextLayoutModel: NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSArray<id<TETextImageModel>>* imageArray;
@property (strong, nonatomic) NSArray<id<TETextLinkModel>>* linkArray;
@property (strong, nonatomic) NSAttributedString *content;

@end


