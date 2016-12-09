//
//  TEBubbleCell.h
//  Telescope
//
//  Created by zhangguang on 16/12/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TETextLayoutModel.h"

@class TEMessage;

@interface TEBubbleCell : UITableViewCell

- (void)setMessage:(TEMessage*)message;

@end
