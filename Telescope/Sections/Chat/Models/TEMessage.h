//
//  TEMessage.h
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TETextLayoutModel.h"

@interface TEMessage : NSManagedObject


@property (nonatomic,readonly) TETextLayoutModel* layoutModel;

@end
