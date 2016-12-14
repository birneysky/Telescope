//
//  TEMessageContentView.h
//  Telescope
//
//  Created by zhangguang on 16/12/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TETextLayoutView;

@interface TEMessageView : UIImageView

@property (nonatomic,readonly) TETextLayoutView* layoutView;

@property (nonatomic,assign) UIEdgeInsets contentInset;

@end
