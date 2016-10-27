//
//  ActiveWheel.h
//  V2_Conference
//
//  Created by zhangguang on 14/12/10.
//  Copyright (c) 2014年 com.v2tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface TEActiveWheel : MBProgressHUD

@property(nonatomic,copy) NSString* processString;
@property(nonatomic,copy) NSString* toastString;
@property(nonatomic,copy) NSString* warningString;

+ (TEActiveWheel*)showHUDAddedTo:(UIView *)view;
+ (TEActiveWheel*)showHUDAddedToWindow:(UIWindow *)window;

+ (void )showErrorHUDAddedTo:(UIView*) view errText:(NSString*)text;

+ (void)showWarningHUDAddedTo:(UIView *)view warningText:(NSString *)text;

+ (void)showPromptHUDAddedTo:(UIView*)view text:(NSString*)text;

+ (void)dismissForView:(UIView*)view;

+ (void)dismissForView:(UIView *)view delay:(NSTimeInterval)interval;

+ (void)dismissViewDelay:(NSTimeInterval)interval forView:(UIView*)view warningText:(NSString*)text;


@end
