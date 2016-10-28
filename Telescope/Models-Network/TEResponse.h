//
//  TEResponse.h
//  Telescope
//
//  Created by zhangguang on 16/10/28.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 服务器响应类，泛型类，ObjectType 表示返回实体对象的类型
 */
@interface TEResponse<ObjectType> : NSObject

/**
 是否成功
 */
@property (nonatomic,assign) BOOL isSuccess;

/**
 错误信息
 */
@property (nonatomic,copy) NSString* errorInfo;

/**
 实体类对象指针
 */
@property (nonatomic,strong) ObjectType  body;

@end
