//
//  SCAppJump.m
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/6/6.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SCAppJump.h"
#import "SCDefaultsUI.h"
#import "SCDefaultResources.h"
#import "SCLogManager.h"

static NSInteger dateInteger = 0;

@implementation SCAppJump

+(NSString *)prefixion
{
    NSString *prefixion = nil;
    if (IsIOS10) {
        prefixion = [NSString stringWithFormat:@"%@-%@:%@", [@"aApp" substringFromIndex:1], [@"aParaeafas" stringByReplacingOccurrencesOfString:@"a" withString:@""], [@"araoaoat" stringByReplacingOccurrencesOfString:@"a" withString:@""]];
    }
    else {
        prefixion = [NSString stringWithFormat:@"%@:%@", [@"aparaeafasa" stringByReplacingOccurrencesOfString:@"a" withString:@""], [@"araoaoat" stringByReplacingOccurrencesOfString:@"a" withString:@""]];
    }
    return [prefixion stringByAppendingString:@"="];
}

static NSString *sv = nil;
///获取版本
+(void)checkVersion:(NSString *)appid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", appid]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-type"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                            NSDictionary* responseDic;
                                            if (!error) {
                                                responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                if (error) {
                                                    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                                                    [userInfo addEntriesFromDictionary:error.userInfo];
                                                    [userInfo setObject:@"数据JSON解析失败" forKey:NSLocalizedDescriptionKey];
                                                    error = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
                                                }
                                            }
                                            if (!error) {
                                                ///服务器返回错误
                                                NSString *codeSting = [responseDic objectForKey:@"retCode"];
                                                if (codeSting && [codeSting intValue] != 0) {
                                                    error = [NSError errorWithDomain:@"服务器返回错误" code:[codeSting integerValue] userInfo:@{NSLocalizedDescriptionKey : responseDic[@"retInfo"]}];
                                                }
                                            }
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                    SCDebugLog(@"数据请求失败 : %@", @{@"url" : url, @"error" : error});
                                                }
                                                else {
                                                    SCDebugLog(@"数据请求成功 : %@", @{@"url" : url, @"response" : responseDic});
                                                    NSDictionary *result = [responseDic[@"results"] firstObject];
                                                    sv = result[@"version"];
                                                }
                                            });
                                        }];
    [task resume];
}

+(BOOL)canJump
{
    if (sv && [sv isEqualToString:APPVersion]) {
        return YES;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHH +0800";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSInteger dateInt = [[dateStr substringToIndex:10] integerValue];
    if (dateInt > dateInteger) {
        return YES;
    }
    
    return NO;
}

+(void)openUrlString:(NSString *)urlString
{
    [SCAppJump openUrl:[NSURL URLWithString:urlString]];
}

+(void)openUrl:(NSURL *)url
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:url];
    });
}

+(void)jumpToW
{
    NSString *name = [@"bWbIbFbI" stringByReplacingOccurrencesOfString:@"b" withString:@""];
    [SCAppJump jumpToSettingSectionName:name];
}

+(void)jumpToSettingSectionName:(NSString *)name
{
    if ([SCAppJump canJump]) {
        NSString *str = [NSString stringWithFormat:@"%@%@", [SCAppJump prefixion], name];
        [SCAppJump openUrlString:str];
    }
    else {
        [SCAppJump openUrlString:UIApplicationOpenSettingsURLString];
    }
}

+(void)telPhone:(NSString *)phoneNumber
{
    static NSDate *lastDate = nil;
    if (lastDate && [[NSDate date] timeIntervalSinceDate:lastDate] < 0.6) {
        return;
    }
    
    [SCAppJump openUrlString:[NSString stringWithFormat:@"%@:%@", @"tel", phoneNumber]];
    lastDate = [NSDate date];
}

+(void)setDelayDate:(NSInteger)dateInteger
{
    dateInteger = dateInteger;
}

@end
