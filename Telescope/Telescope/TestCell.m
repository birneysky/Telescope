//
//  TestCell.m
//  Telescope
//
//  Created by zhangguang on 16/9/21.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TestCell.h"

@interface TestCell ()
@property (weak, nonatomic) IBOutlet UILabel *accessoryLabel;

@end

@implementation TestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
