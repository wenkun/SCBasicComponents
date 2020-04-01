//
//  SCLogManager.h
//  SCBasicComponents_Example
//
//  Created by 文堃 杜 on 2018/2/9.
//  Copyright © 2018年 wenkun. All rights reserved.
//

#import <Foundation/Foundation.h>

///Log标签[ERROR]
extern NSString * const SCLogErrorTag;
///Log标签[WARN]
extern NSString * const SCLogWarnTag;
///Log标签[INFO]
extern NSString * const SCLogInfoTag;
///Log标签[DEBUG]
extern NSString * const SCLogDebugTag;

///Log等级
typedef enum : NSUInteger {
    SCLogLevelNone,
    SCLogLevelProduct,
    SCLogLevelDebug,
    SCLogLevelPrivate,
} SCLogLevel;


#if DEBUG

//生产log
#define SCLog(FORMAT, ...) if([SCLogManager share].level >= SCLogLevelProduct) [SCLogManager logWithFormat:(FORMAT @"\n %s[%d]"), ##__VA_ARGS__, __FUNCTION__, __LINE__]
//debug log
#define SCDebugLog(FORMAT, ...) [SCLogManager logWithFormat:(@"[D]" FORMAT @"\n %s[%d]"), ##__VA_ARGS__, __FUNCTION__, __LINE__]
//私有log
#define SCPLog(FORMAT, ...) [SCLogManager logWithFormat:(@"[DP]" FORMAT @"\n %s[%d]"), ##__VA_ARGS__, __FUNCTION__, __LINE__]

#else

//生产log
#define SCLog(FORMAT, ...) if([SCLogManager share].level >= SCLogLevelProduct) [SCLogManager logWithFormat:(FORMAT @"\n %s"), ##__VA_ARGS__, __FUNCTION__]
//debug log
#define SCDebugLog(FORMAT, ...) if([SCLogManager share].level >= SCLogLevelDebug) [SCLogManager logWithFormat:(@"[D]" FORMAT @"\n %s[%d]"), ##__VA_ARGS__, __FUNCTION__, __LINE__]
//私有log
#define SCPLog(FORMAT, ...) if([SCLogManager share].level == SCLogLevelPrivate) [SCLogManager logWithFormat:(@"[DP]" FORMAT @"\n %s[%d]"), ##__VA_ARGS__, __FUNCTION__, __LINE__]

#endif

@protocol SCLogManagerDelegate;

/**
 Log打印管理类。
 使用说明：
 1、用户隐私信息请使用SCPLog打印。
 2、Log里请手动添加事件的标签，例如添加Error标签：SCLog(@"[uSDK][ERROR] = %@", error)，[uSDK]为模块标签，常用标签有：[ERROR][DEBUG][WARN][INFO]。便签功能是为了方便Log检索。
 */
@interface SCLogManager : NSObject
///代理
@property (nonatomic, weak) id<SCLogManagerDelegate>delegate;
///Log等级
@property (nonatomic, assign) SCLogLevel level;
///Log存储到本地的最长存储天数，默认5天
@property (nonatomic, assign) NSInteger logSaveDays;
///Log存储到本地的最多文件数量(包含正在写入的文件)，0为不限制数量，默认为0
@property (nonatomic, assign) NSInteger maxLogFileCount;
///Log存储到本地的文件最大大小，单位M，0为不限，超过大小后更换新文件写入，默认为0
@property (nonatomic, assign) float maxLogFileSize;
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
-(void)startLogAndWriteToFile;

/**
 停止log输出
 */
-(void)stopLogWriteToFile;

/// 删除过期log文件及压缩文件
-(void)deleteExpireLogFile;

/// 返回所有Log文件路径，按文件创建时间排序
-(NSArray *)logFilePaths;

@end


@protocol SCLogManagerDelegate <NSObject>
@optional

/// 默认为 yyyyMMddHHmmss
- (NSString *)logFileName;
/// Log头部描述添加
- (NSString *)logHeaderAppending;
/// 开始将Log写入本地文件，包括切换新Log文件
- (void)startWriteLogToFile;

@end
