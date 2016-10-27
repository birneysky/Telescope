//
//  ActiveWheel.m
//  V2_Conference
//
//  Created by zhangguang on 14/12/10.
//  Copyright (c) 2014年 com.v2tech. All rights reserved.
//

#import "TEActiveWheel.h"
//#import "Toast+UIView.h"

//static const NSString* startLabelText = @"正在处理";
//static const NSString* timeoutText = @"处理超时";

@interface TEActiveWheel ()
@property (nonatomic) BOOL* ptimeoutFlag;
@end

@implementation TEActiveWheel

- (id)initWithView:(UIView *)view
{
    self = [super initWithView:view];
    if (self) {
    }
    return self;
}

-(id)initWithWindow:(UIWindow *)window{
    self = [super initWithWindow:window];
    if (self) {
        
    }
    return self;
}

-(void)dealloc
{
    self.processString = nil;
}


+ (TEActiveWheel*)showHUDAddedTo:(UIView *)view
{
    TEActiveWheel* hud = [[TEActiveWheel alloc] initWithView:view];
    hud.contentColor = [UIColor whiteColor];
    [view addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}

+ (TEActiveWheel *)showHUDAddedToWindow:(UIWindow *)window{
    TEActiveWheel* hud = [[TEActiveWheel alloc] initWithView:window];
    hud.contentColor = [UIColor whiteColor];
    [window addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}


+ (void )showErrorHUDAddedTo:(UIView*) view errText:(NSString*)text;
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"HOAKit.bundle/HA_Error_Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hud.square = YES;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Optional label text.
    hud.label.text = text;
    //hud.label.textColor = [UIColor redColor];
    
    [hud hideAnimated:YES afterDelay:3.f];
}

+ (void)showWarningHUDAddedTo:(UIView *)view warningText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"HOAKit.bundle/HA_Warning_Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.square = YES;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Optional label text.
    hud.label.text = text;
    //hud.label.textColor = [UIColor redColor];
    
    [hud hideAnimated:YES afterDelay:3.f];
}

+ (void)showPromptHUDAddedTo:(UIView*)view text:(NSString*)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
     hud.label.textColor = [UIColor whiteColor];
    
    [hud hideAnimated:YES afterDelay:2.0f];
}


+(void)dismissForView:(UIView*)view
{
    MBProgressHUD* hud = [super HUDForView:view];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES];


}

+ (void)dismissViewDelay:(NSTimeInterval)interval forView:(UIView*)view warningText:(NSString*)text;
{
    TEActiveWheel* wheel = (TEActiveWheel*)[super HUDForView:view];;
    [wheel performSelector:@selector(setWarningString:) withObject:text afterDelay:0];
    [TEActiveWheel performSelector:@selector(dismissForView:) withObject:view afterDelay:interval];
}

+ (void)dismissForView:(UIView *)view delay:(NSTimeInterval)interval
{
    [TEActiveWheel performSelector:@selector(dismissForView:) withObject:view afterDelay:interval];
}

- (void)setProcessString:(NSString *)processString
{
    //self.labelColor = [UIColor colorWithRed:219/255.0f green:78/255.0f blue:32/255.0f alpha:1];
    self.label.text = processString;
}

- (void)setWarningString:(NSString *)warningString
{
    //self.label.textColor = [UIColor redColor];
    self.label.text = warningString;
}

@end
