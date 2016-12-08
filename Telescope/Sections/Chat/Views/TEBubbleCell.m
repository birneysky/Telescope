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

@property (nonatomic,strong) UIButton* headImageBtn;



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

- (UIButton*) headImageBtn
{
    if (!_headImageBtn) {
        _headImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 44, 44)];
    }
    return _headImageBtn;
}


#pragma mark - *** Init ***
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView addSubview:self.layoutView];
    [self.contentView addSubview:self.headImageBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - *** Api ***

- (void)setLayoutModel:(TETextLayoutModel*)model
{
    
    self.layoutView.frame = CGRectMake(self.headImageBtn.rightTop.x, 8, 375, model.height);
    
    [self.layoutView setLayoutModel:model];
}

@end
