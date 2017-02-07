//
//  CTDisplayView.h
//  CoreTextDemo
//
//  Created by TangQiao on 13-12-7.
//  Copyright (c) 2013年 TangQiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TETextLayoutModel.h"

extern NSString *const TETextLayoutViewImagePressedNotification;
extern NSString *const CTDisplayViewLinkPressedNotification;

@protocol TETextLayoutViewDelegate <NSObject>

- (void)didSelectImageOfRect:(CGRect)rect inView:(UIView*)view;

- (void)didSelectLinkOfURL:(NSString*)url;

@end

@interface TETextLayoutView : UIView

@property (strong, nonatomic) TETextLayoutModel * layoutModel;

@property (weak,   nonatomic) id<TETextLayoutViewDelegate> delegate;

@end
