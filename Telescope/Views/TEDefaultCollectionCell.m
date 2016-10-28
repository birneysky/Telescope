//
//  TEDefaultCollectionCell.m
//  Telescope
//
//  Created by zhangguang on 16/10/28.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEDefaultCollectionCell.h"

@interface TEDefaultCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;


@end

@implementation TEDefaultCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHeadImage:(UIImage*)img
{
    self.headImageView.image = img;
}

@end
