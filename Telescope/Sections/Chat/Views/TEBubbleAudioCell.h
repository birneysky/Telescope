//
//  TEBubbleAudioCell.h
//  Telescope
//
//  Created by zhangguang on 17/1/20.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import "TEBubbleCell.h"

@protocol TEBubbleAudioPlayDelegate <NSObject>

- (void)didSelectAudioCell:(UITableViewCell*)cell fileName:(NSString*)fileName;

@end

@interface TEBubbleAudioCell : TEBubbleCell

@property (nonatomic,weak) id<TEBubbleAudioPlayDelegate> playDelegate;

- (void)startAnimating;
- (void)stopAnimating;



@end
