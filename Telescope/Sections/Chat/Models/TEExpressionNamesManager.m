//
//  TEFaceInfoManager.m
//  Telescope
//
//  Created by zhangguang on 16/12/12.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEExpressionNamesManager.h"


static TEExpressionNamesManager* manager;

@interface TEExpressionNamesManager ()

@property (nonatomic,strong) NSArray* names;

@end

@implementation TEExpressionNamesManager

#pragma mark - *** Initializers ***
+ (TEExpressionNamesManager*)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TEExpressionNamesManager alloc] init];
    });
    return manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (!manager) {
        return  manager = [super allocWithZone:zone];
    }
    return nil;
}


- (instancetype)init{
    if (self = [super init]) {
        NSString * facePlistPath = [[NSBundle mainBundle] pathForResource:@"TEExpressionNames" ofType:@"plist"];
        NSArray* temp = [NSArray arrayWithContentsOfFile:facePlistPath];
        NSMutableArray* tempMutable = [[NSMutableArray alloc] initWithCapacity:50];
        for (int i = 0; i < temp.count; i++) {
            NSString* faceString =  temp[i];//NSLocalizedString(temp[i], nil);
            [tempMutable addObject:faceString];
        }
        _names = [tempMutable copy];
    }
    return self;
}

@end
