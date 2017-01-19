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


/**
 连接标题
 */
@property (copy, nonatomic) NSString * title;

/**
 连接地址
 */
@property (copy, nonatomic) NSString * url;


/**
 连接所在的范围
 */
@property (assign, nonatomic) NSRange range;

@end



typedef NS_ENUM(NSInteger,TEPlaceholderType){
    PlaceholderImageType,
    PlaceholderAudioType,
    PlaceholderDocumentType
};


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


@property (nonatomic,readonly) TEPlaceholderType holderType;


///**
// 缩略图文件名
// */
//@optional
//@property (readonly, nonatomic) NSString* thumbnailImageName;

@end


#endif /* TETextLayoutModelProtocol_h */
