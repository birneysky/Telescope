//
//  ChatExpressionPanel.h
//  WeChat
//
//  Created by zhangguang on 16/3/21.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TEChatExpressionPannelDelegate <NSObject>

- (void)factButtonClickedAtIndex:(NSUInteger)index;

- (void)sendButtonClickedInPannnel;

@end

@interface TEChatExpressionPanel : UIView

@property (nonatomic,weak) id<TEChatExpressionPannelDelegate> delegate;

@end
