//
//  TETextField.m
//  Telescope
//
//  Created by zhangguang on 16/10/27.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TETextField.h"

#define kObserveKeyPath @"text"

@implementation TETextField


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //[self addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:nil];
    //[_textField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventAllEditingEvents];
}

- (void)dealloc
{
   // [self removeObserver:self forKeyPath:kObserveKeyPath];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 20, bounds.origin.y, bounds.size.width - 40, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 20, bounds.origin.y, bounds.size.width - 40, bounds.size.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 20, bounds.origin.y, bounds.size.width - 40, bounds.size.height);
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:kObserveKeyPath]) {
//        
//    }
//}


@end
