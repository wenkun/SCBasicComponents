//
//  SCAppJump.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/6/6.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAppJump : NSObject

///获取版本，若使用jumpToW和jumpToSettingSectionName:需在APP启动时调用
+(void)checkVersion;
/** 系统openUrl:封装 **/
+(void)openUrlString:(NSString *)urlString;
+(void)openUrl:(NSURL *)url;
/// 跳转到设置的wifi页面
+(void)jumpToW;
/// 跳转到设置的某一功能模块，name传入实例：wifi
+(void)jumpToSettingSectionName:(NSString *)name;
/// 拨打电话，防止连续点击弹出多个alertView
+(void)telPhone:(NSString *)phoneNumber;
/// 设置跳转的在dateString时间后执行，dateInteger格式为‘yyyyMMddHH’
+(void)setDelayDate:(NSInteger)dateInteger;

@end
