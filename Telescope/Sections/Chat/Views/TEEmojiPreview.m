//
//  TEEmojiPreview.m
//  Telescope
//
//  Created by zhangguang on 17/1/9.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import "TEEmojiPreview.h"

@interface TEEmojiPreview ()
@property (weak, nonatomic) IBOutlet UIImageView *emojiImageView;
@property (weak, nonatomic) IBOutlet UILabel *emojiNameLabel;

@end

@implementation TEEmojiPreview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)emojiPreview
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TEEmojiPreview" owner:self options:nil] lastObject];
}

- (void)showFromView:(UIView*)view
{
    UIWindow* window = [UIApplication sharedApplication].windows.lastObject;
    if (!self.superview) {
        [window addSubview:self];
    }
    
    CGRect frameInWindow =  [view convertRect:view.bounds toView:nil];

    NSLog(@"frame in window %@",NSStringFromCGRect(frameInWindow));
    self.center = (CGPoint){frameInWindow.origin.x + frameInWindow.size.width / 2, frameInWindow.origin.y - frameInWindow.size.height / 2};
}



- (void)setPreviewImage:(UIImage*)image
{
    self.emojiImageView.image = image;
}

- (void)setEmojiName:(NSString*)name
{
    self.emojiNameLabel.text = name;
}


@end
