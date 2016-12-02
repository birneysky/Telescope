//
//  TEChatTableViewController.h
//  Telescope
//
//  Created by zhangguang on 16/12/1.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEFetchTableViewController.h"

@class TEChatSession;
@interface TEChatTableViewController : TEFetchTableViewController


@property (nonatomic,weak) TEChatSession* session;

@end
