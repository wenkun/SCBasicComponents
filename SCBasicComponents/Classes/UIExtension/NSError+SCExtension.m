//
//  NSError+SCExtension.m
//  GoodAir
//
//  Created by 文堃 杜 on 2017/5/16.
//  Copyright © 2017年 青岛海尔科技有限公司. All rights reserved.
//


NSString * const SErrorCodeStringKey = @"SCodeStringKey";
NSString *const SErrorCodeNotIntValue = @"-111111";

#import "NSError+SCExtension.h"

@implementation NSError (SCExtension)

-(NSString *)codeString
{
    NSString *codeString = [self.userInfo objectForKey:SErrorCodeStringKey];
    if (!codeString && self.code != 0) {
        codeString = [NSString stringWithFormat:@"%ld", self.code];
    }
    return codeString;
}

/**
 生成一个NSError对象。
 
 @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil. See Error Domains for a list of predefined domains.
 @param code The error code for the error.
 @param description 错误描述，NSLocalizedDescriptionKey的对应值。
 @return NSError对象。
 */
+(instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code description:(NSString *)description
{
    return [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey : description}];
}

/**
 生成一个NSError对象，针对非整型的错误码。
 如果错误码codeString可以转成整型，则赋值给code属性；否则code的值统一为SErrorCodeNotIntValue。

 @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil. See Error Domains for a list of predefined domains.
 @param codeString NSString类型的code
 @param description 错误描述
 @return NSError对象
 */
+(instancetype)errorWithDomain:(NSErrorDomain)domain codeString:(NSString *)codeString description:(NSString *)description
{
    NSInteger code = 0;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if (codeString) {
        code = [codeString integerValue];
        if (code == 0) {
            code = [SErrorCodeNotIntValue integerValue];
        }
        
        [userInfo setObject:codeString forKey:SErrorCodeStringKey];
    }
    
    if (description) {
        [userInfo setObject:description forKey:NSLocalizedDescriptionKey];
    }
    
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
    return error;
}

@end
