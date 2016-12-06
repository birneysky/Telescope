//
//  TEXmlChatData.h
//  Telescope
//
//  Created by zhangguang on 16/12/6.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEXmlModel.h"
#import "TEXmlItemList.h"

@interface TEXmlChatData : TEXmlModel

@property (nonatomic,assign) BOOL isAutoReply;
@property (nonatomic,strong) TEXmlItemList* msgItemList;
@property (nonatomic,copy) NSString* messageID;

@end
