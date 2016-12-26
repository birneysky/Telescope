//
//  TEMessage.h
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TEBubbleCellInnerLayout.h"

@interface TEMessage : NSManagedObject


/**
 消息模型
 */
@property (nonatomic,strong) TEChatMessage* chatMessage;

@property (nonatomic,readonly) TEBubbleCellInnerLayout* layout;



@end
