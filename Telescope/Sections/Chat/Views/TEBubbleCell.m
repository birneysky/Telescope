//
//  TEBubbleCell.m
//  Telescope
//
//  Created by zhangguang on 16/12/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEBubbleCell.h"
#import "TETextLayoutView.h"

@interface TEBubbleCell ()

@property (nonatomic,strong) TETextLayoutView* layoutView;

@end

@implementation TEBubbleCell

#pragma mark - *** Properties ***
- (TETextLayoutView*)layoutView
{
    if (!_layoutView) {
        _layoutView = [[TETextLayoutView alloc] init];
    }
    return _layoutView;
}

#pragma mark - *** Init ***
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView addSubview:self.layoutView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - *** Api ***

- (void)setLayoutModel:(TETextLayoutModel*)model
{
    self.layoutView.frame = CGRectMake(0, 0, 375, model.height);
    [self.layoutView setLayoutModel:model];
}

@end
