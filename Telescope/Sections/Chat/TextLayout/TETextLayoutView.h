//
//  CTDisplayView.h
//  CoreTextDemo
//
//  Created by TangQiao on 13-12-7.
//  Copyright (c) 2013年 TangQiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TETextLayoutModel.h"

extern NSString *const CTDisplayViewImagePressedNotification;
extern NSString *const CTDisplayViewLinkPressedNotification;

@interface TETextLayoutView : UIView

@property (strong, nonatomic) TETextLayoutModel * layoutModel;

@end
