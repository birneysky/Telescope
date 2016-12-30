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


@protocol TETextPlaceholderModel <NSObject>

/**
 占位索引
 */
@property (nonatomic,assign) NSUInteger index;

/**
 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
 */
@property (nonatomic,assign) CGRect frame;


/**
 文件路径
 */
@property (copy, nonatomic) NSString* path;


/**
 文件名称
 */
@property (copy, nonatomic) NSString* fileName;


/**
 文件扩展名
 */
@property (copy,nonatomic) NSString* fileExt;


@property (nonatomic,readonly) BOOL isAPicture;

@end


#endif /* TETextLayoutModelProtocol_h */
