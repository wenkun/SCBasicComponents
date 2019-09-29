//
//  NSNumber+SCExtension.h
//  SCBasicComponents_Example
//
//  Created by 星星 on 2018/3/1.
//  Copyright © 2018年 wenkun. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSNumber (SCExtension)
/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (nullable NSNumber *)numberWithString:(NSString *)string;
@end
NS_ASSUME_NONNULL_END
