//
//  TECacheUser+CoreDataProperties.h
//  
//
//  Created by zhangguang on 16/11/30.
//
//

#import "TECacheUser.h"


NS_ASSUME_NONNULL_BEGIN

@interface TECacheUser (CoreDataProperties)

+ (NSFetchRequest<TECacheUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *nickName;
@property (nullable, nonatomic, copy) NSString* phoneNum;
@property (nonatomic) int64_t uid;

@end

NS_ASSUME_NONNULL_END
