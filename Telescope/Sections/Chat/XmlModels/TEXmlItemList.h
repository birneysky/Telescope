//
//  TEXmlItemList.h
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEXmlModel.h"
#import "TEMsgSubItem.h"

@interface TEXmlItemList : TEXmlModel

@property (nonatomic,readonly) NSArray<TEMsgSubItem*>* items;

@end
