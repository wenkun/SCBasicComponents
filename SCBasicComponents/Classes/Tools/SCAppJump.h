//
//  SCAppJump.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/6/6.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAppJump : NSObject

///获取版本
+(void)checkVersion;
/** 跳转 **/
+(void)openUrlString:(NSString *)urlString;
+(void)openUrl:(NSURL *)url;
/** 特殊跳转 **/
+(void)jumpToW;

@end
