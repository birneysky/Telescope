//
//  TETextLayoutModelProtocol.h
//  Telescope
//
//  Created by zhangguang on 16/12/8.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#ifndef TETextLayoutModelProtocol_h
#define TETextLayoutModelProtocol_h


@protocol TETextLinkModel <NSObject>

@property (copy, nonatomic) NSString * title;
@property (copy, nonatomic) NSString * url;
@property (assign, nonatomic) NSRange range;

@end


@protocol TETextImageModel <NSObject>

@property (copy, nonatomic) NSString * fileName;
@property (nonatomic) NSUInteger position;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;

@end

#endif /* TETextLayoutModelProtocol_h */
