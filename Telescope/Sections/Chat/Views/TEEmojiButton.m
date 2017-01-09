//
//  TEFaceButton.m
//  Telescope
//
//  Created by zhangguang on 17/1/9.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import "TEEmojiButton.h"

@implementation TEEmojiButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return (CGRect){8,8,contentRect.size.width - 16,contentRect.size.height-16};
}



@end
