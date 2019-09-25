
//
//  SHDebugTool.m
//  Robot
//
//  Created by 星星 on 2018/7/11.
//  Copyright © 2018年 Haier. All rights reserved.
//
#import "NSURLSessionConfiguration+SHDebugTool.h"
#import <objc/runtime.h>
#import "SHDTURLProtocol.h"

@implementation NSURLSessionConfiguration (SHDebugTool)
#ifdef DEBUG
+ (void)load {
    Method method1 = class_getClassMethod([NSURLSessionConfiguration class], @selector(defaultSessionConfiguration));
    Method method2 = class_getClassMethod([NSURLSessionConfiguration class], @selector(SH_defaultSessionConfiguration));
    method_exchangeImplementations(method1, method2);

    Method method3 = class_getClassMethod([NSURLSessionConfiguration class], @selector(ephemeralSessionConfiguration));
    Method method4 = class_getClassMethod([NSURLSessionConfiguration class], @selector(SH_ephemeralSessionConfiguration));
    method_exchangeImplementations(method3, method4);
}

+ (NSURLSessionConfiguration *)SH_defaultSessionConfiguration {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration SH_defaultSessionConfiguration];
    NSMutableArray *protocols = [[NSMutableArray alloc] initWithArray:config.protocolClasses];
    if (![protocols containsObject:[SHDTURLProtocol class]]) {
        [protocols insertObject:[SHDTURLProtocol class] atIndex:0];
    }
    config.protocolClasses = protocols;
    return config;
}

+ (NSURLSessionConfiguration *)SH_ephemeralSessionConfiguration {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration SH_ephemeralSessionConfiguration];
    NSMutableArray *protocols = [[NSMutableArray alloc] init];
    [protocols addObjectsFromArray:config.protocolClasses];
    if (![protocols containsObject:[SHDTURLProtocol class]]) {
        [protocols insertObject:[SHDTURLProtocol class] atIndex:0];
    }
    config.protocolClasses = protocols;
    return config;
}

#endif
@end
