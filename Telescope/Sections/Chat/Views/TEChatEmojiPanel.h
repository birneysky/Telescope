//
//  ChatExpressionPanel.h
//  WeChat
//
//  Created by zhangguang on 16/3/21.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TEChatEmojiPannelDelegate <NSObject>

- (void)factButtonClickedAtIndex:(NSUInteger)index;

- (void)sendButtonClickedInPannnel;

@end

@interface TEChatEmojiPanel : UIView

@property (nonatomic,weak) id<TEChatEmojiPannelDelegate> delegate;

@end
