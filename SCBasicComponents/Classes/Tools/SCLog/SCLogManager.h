//
//  SCLogManager.h
//  SCBasicComponents_Example
//
//  Created by 文堃 杜 on 2018/2/9.
//  Copyright © 2018年 wenkun. All rights reserved.
//

///Log标签[ERROR]
extern NSString * const SCLogErrorTag;
///Log标签[WARN]
extern NSString * const SCLogWarnTag;
///Log标签[INFO]
extern NSString * const SCLogInfoTag;
///Log标签[DEBUG]
extern NSString * const SCLogDebugTag;


//在SCLogWriteToFile为1时，Log写入文件，需手动为该log加入标签
#define SCLog(FORMAT, ...) [SCLogManager logWithFormat:(@"[SC]" FORMAT @"[%s]"), ##__VA_ARGS__, __FUNCTION__]
//SCDebugLog永不写入本地，并且只有在DEBUG下才生效
#if (SCLogWriteToFile && !DEBUG)
#define SCDebugLog(FORMAT, ...)
#else
#define SCDebugLog(FORMAT, ...) [SCLogManager logWithFormat:(@"[DEBUG]" FORMAT), ##__VA_ARGS__]
#endif

#import <Foundation/Foundation.h>

/**
 Log打印管理类。
 使用说明：
    1、开启Log写入本地沙盒功能，需先在Macros里设置SCLogWriteToFile为1，然后调用[startLogAndWriteToFile]方法启动Log写入本地功能。
    2、用户隐私信息请不要使用SCLog打印。
    3、Log里请手动添加事件的标签，例如添加Error标签：SCLog(@"[uSDK][ERROR] = %@", error)，[uSDK]为模块标签，常用标签有：[ERROR][DEBUG][WARN][INFO]。便签功能是为了方便Log检索。
 */
@interface SCLogManager : NSObject

///Log存储到本地的最长存储天数，默认7天
@property (nonatomic, assign) NSInteger logSaveDays;
///
@property (nonatomic, readonly) NSArray *logFilePaths;

///单例
+(instancetype)share;

/**
 重定义log打印，对于长度长于1024字节的进行循环打印

 @param format :A format string. See Formatting String Objects for examples of how to use this method, and String Format Specifiers for a list of format specifiers. This value must not be nil.

 */
+(void)logWithFormat:(NSString *)format, ...;

/**
 开始log写入本地文件。
 一旦启用改方法，请勿使用SCLog和SCDebugLog之外的log打印方法！！！
 */
+(void)startLogAndWriteToFile;

@end


@protocol SCLogManagerDelegate <NSObject>
@optional

- (NSString *)logFileName;
- (NSString *)logHeaderWithDefaultHeader:(NSString *)defaultHeader;

@end
