//
//  TEMediaFileLocation+CoreDataProperties.h
//  
//
//  Created by zhangguang on 16/12/26.
//
//

#import "TEMediaFileLocation.h"


NS_ASSUME_NONNULL_BEGIN

@interface TEMediaFileLocation (CoreDataProperties)

+ (NSFetchRequest<TEMediaFileLocation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *fileID;
@property (nullable, nonatomic, copy) NSDate *saveTime;
@property (nonatomic) int32_t sessionID;
@property (nonatomic) int16_t fileType;
@property (nullable, nonatomic, copy) NSString* fileExt;

@end

NS_ASSUME_NONNULL_END
