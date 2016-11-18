//
//  TEAnnotation.h
//  Telescope
//
//  Created by zhangguang on 16/11/16.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TEAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;


- (nonnull instancetype) initWithCoordinate:(CLLocationCoordinate2D) coordinate;

@end
