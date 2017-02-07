//
//  TEBubbleAudioCell.h
//  Telescope
//
//  Created by zhangguang on 17/1/20.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import "TEBubbleCell.h"

@protocol TEBubbleAudioCellDelegate <NSObject>

- (void)didSelectAudioOfFile:(NSString*)fileName;

@end

@interface TEBubbleAudioCell : TEBubbleCell


@end
