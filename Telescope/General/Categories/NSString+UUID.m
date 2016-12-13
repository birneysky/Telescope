//
//  NSString+UUID.m
//  Telescope
//
//  Created by zhangguang on 16/12/13.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)

+(NSString*)UUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    
    CFRelease(uuid_string_ref);
    
    return uuid;
}

@end
