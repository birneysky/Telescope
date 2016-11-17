//
//  TEAnnotation.m
//  Telescope
//
//  Created by zhangguang on 16/11/16.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEAnnotation.h"

@implementation TEAnnotation


- (instancetype) initWithCoordinate:(CLLocationCoordinate2D) coordinate
{
    if (self = [super init]) {
        self.coordinate = coordinate;
    }
    return self;
}

@end
