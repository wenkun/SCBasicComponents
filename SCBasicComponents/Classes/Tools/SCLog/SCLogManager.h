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
#define SCLog(FORMAT, ...) [SCLogManager logWithFormat:(FORMAT @"\n %s"), ##__VA_ARGS__, __FUNCTION__]

//SCDebugLog在DEBUG下才生效
#if DEBUG
#define SCDebugLog(FORMAT, ...) [SCLogManager logWithFormat:(@"[D]" FORMAT @"\n %s[%d]"), ##__VA_ARGS__, __FUNCTION__, __LINE__]
#else
#define SCDebugLog(FORMAT, ...)
#endif

//SCPLog为私有打印，在SCPrivateUser配置为1时生效
#if SCPrivateUser
#define SCPLog(FORMAT, ...) [SCLogManager logWithFormat:(@"[DP]" FORMAT @"\n %s[%d]"), ##__VA_ARGS__, __FUNCTION__, __LINE__]
#else
#define SCPLog(FORMAT, ...)
#endif

#import <Foundation/Foundation.h>
@protocol SCLogManagerDelegate;

/**
 Log打印管理类。
 使用说明：
    1、开启Log写入本地沙盒功能，需先在Macros里设置SCLogWriteToFile为1，然后调用[startLogAndWriteToFile]方法启动Log写入本地功能。
    2、用户隐私信息请不要使用SCLog打印。
    3、Log里请手动添加事件的标签，例如添加Error标签：SCLog(@"[uSDK][ERROR] = %@", error)，[uSDK]为模块标签，常用标签有：[ERROR][DEBUG][WARN][INFO]。便签功能是为了方便Log检索。
 */
@interface SCLogManager : NSObject
///代理
@property (nonatomic, weak) id<SCLogManagerDelegate>delegate;
///Log存储到本地的最长存储天数，默认7天
@property (nonatomic, assign) NSInteger logSaveDays;
///Log存储到本地的最多文件数量(包含正在写入的文件)，0为不限制数量，默认为0
@property (nonatomic, assign) NSInteger maxLogFileCount;
///Log存储到本地的文件最大大小，单位M，0为不限，超过大小后更换新文件写入，默认为0
@property (nonatomic, assign) CGFloat maxLogFileSize;
///本地所有的Log文件路径
@property (nonatomic, readonly) NSArray *logFilePaths;
///当前沙盒log文件的名称
@property (nonatomic, readonly) NSString *currentLogFilePath;

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

/**
 停止log输出
 */
+(void)stopLogWriteToFile;

@end


@protocol SCLogManagerDelegate <NSObject>
@optional

/// 默认为 yyyyMMddHHmmss
- (NSString *)logFileName;
/// Log头部描述添加
- (NSString *)logHeaderAppending;

@end
