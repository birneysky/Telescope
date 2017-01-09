//
//  TEFaceInfoManager.h
//  Telescope
//
//  Created by zhangguang on 16/12/12.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEEmojiNamesManager : NSObject

- (NSString*)nameAtIndex:(NSInteger)index;

- (NSString*)indexOfName:(NSString*)name;

+ (TEEmojiNamesManager*)defaultManager;

@end
