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

@property (nonatomic,copy) NSArray* names;

@property (nonatomic,strong) NSMutableDictionary<NSString*,NSString*>* nameIndexDic;

@end

@implementation TEExpressionNamesManager
#pragma mark - *** Properties ***
- (NSMutableDictionary<NSString*,NSString*>*) nameIndexDic
{
    if (!_nameIndexDic) {
        _nameIndexDic = [[NSMutableDictionary alloc] init];
    }
    return _nameIndexDic;
}

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
            NSString* key = [NSString stringWithFormat:@"[%@]",faceString];
            NSString* value = [NSString stringWithFormat:@"%d",i];
            [self.nameIndexDic setObject:value forKey:key];
        }
        self.names = [tempMutable copy];
    }
    return self;
}

- (NSString*)nameAtIndex:(NSInteger)index
{
    assert(index < self.names.count);
    return self.names[index];
}


- (NSString*)indexOfName:(NSString*)name
{
    return self.nameIndexDic[name];
}


@end
