//
//  SHErrorMessage.m
//  Robot
//
//  Created by 文堃 杜 on 2018/8/9.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHErrorMessage.h"

@implementation SHErrorMessage

+(NSString *)messageOfRequestError:(NSError *)error
{
    if ([error.domain containsString:@"anzhu.home"]) {
        return error.localizedDescription;
    }
    if (NSEqualRanges([error.domain rangeOfString:@"NS"], NSMakeRange(0, 2)) && [error.domain rangeOfString:@"URL"].length > 0) {
        if (error.code == NSURLErrorTimedOut) {
            return @"请求超时";
        }
        else {
            return @"网络异常";
        }
    }
    return @"请求失败";
}

@end
