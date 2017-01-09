//
//  TEEmojiPreview.h
//  Telescope
//
//  Created by zhangguang on 17/1/9.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEEmojiPreview : UIView

+ (instancetype)emojiPreview;

- (void)setPreviewImage:(UIImage*)image;

- (void)setEmojiName:(NSString*)name;

- (void)showFromView:(UIView*)view;

@end
