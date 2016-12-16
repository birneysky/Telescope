//
//  TEBubbleCell.h
//  Telescope
//
//  Created by zhangguang on 16/12/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TETextLayoutModel.h"

@protocol TEBubbleCellDelegate <NSObject>

- (void)didSelectImageOfRect:(CGRect)rect inView:(UIView *)view;

- (void)didSelectLinkOfURL:(NSString *)url;

@end


@class TEMessage;

@interface TEBubbleCell : UITableViewCell

@property (nonatomic,weak) id<TEBubbleCellDelegate> delegate;

- (void)setMessage:(TEMessage*)message;

@end
