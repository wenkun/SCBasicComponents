//
//  SCLogManager.m
//  SCBasicComponents_Example
//
//  Created by 文堃 杜 on 2018/2/9.
//  Copyright © 2018年 wenkun. All rights reserved.
//

#import "SCLogManager.h"
#import "SCDefaultResources.h"
#import "UIDevice+SCExtension.h"

///Log标签[ERROR]
NSString * const SCLogErrorTag = @"[ERROR]";
///Log标签[WARN]
NSString * const SCLogWarnTag = @"[WARN]";
///Log标签[INFO]
NSString * const SCLogInfoTag = @"[INFO]";
///Log标签[DEBUG]
NSString * const SCLogDebugTag = @"[DEBUG]";

@interface SCLogManager ()
{
    FILE* fp;
}
///当前沙盒log文件的名称
@property (nonatomic, strong) NSString *currentLogFileName;
/// 文件大小检测timer
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation SCLogManager

#pragma mark - Life Cycle

+(instancetype)share
{
    static SCLogManager *timerManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timerManager = [[[self class] alloc] init];
    });
    return timerManager;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.logSaveDays = 5;
    }
    return self;
}

#pragma mark - Interface

+(void)logWithFormat:(NSString *)format, ...
{
    va_list ap;
    va_start (ap, format);
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end (ap);
    
//    [[SCLogManager share] writeToEndOfFileWithLogString:body];
    
    NSInteger length = body.length;
    NSInteger i = 0;
    while (length > 1024) {
        NSString *subString = [body substringToIndex:1024];
        if (i > 0) {
            NSLog(@"\n[S]+ %@", subString);
        }
        else {
            NSLog(@"[S] %@", subString);
        }
        body = [body substringFromIndex:1024];
        length = body.length;
        i++;
    }
    if (i > 0) {
        NSLog(@"\n[S]+ %@", body);
    }
    else {
        NSLog(@"[S] %@", body);
    }
}

-(void)startLogAndWriteToFile
{
    [self redirectNSlogToDocumentFolder];
//    SCLog(@"\n==================================================\n\n \t\t iOS LOG BEGIN \n\n  %@  \n==================================================\n ", [SCLogManager mobileMessage]);
}

-(void)stopLogWriteToFile
{
    fclose(stdout);
    fclose(stderr);
}

- (void)setMaxLogFileSize:(float)maxLogFileSize
{
    _maxLogFileSize = maxLogFileSize;
    if (maxLogFileSize > 0) {
        [self beginFileSizeCheckTimer];
    }
    else {
        [self stopFileSizeCheckTimer];
    }
}

#pragma mark - Timer

- (void)beginFileSizeCheckTimer
{
    if (self.timer) {
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) weakself = self;
    dispatch_source_set_event_handler(timer, ^{
        if (weakself.maxLogFileSize > 0) {
            if (weakself.currentLogFilePath) {
                CGFloat size = [self fileSizeWithPath:self.currentLogFilePath];
                if (size >= self.maxLogFileSize) {
                    weakself.currentLogFileName = nil;
                    [weakself startLogAndWriteToFile];
                }
            }
        }
        else {
            [weakself stopFileSizeCheckTimer];
        }
    });
    dispatch_resume(timer);
    
    self.timer = timer;
}

- (void)stopFileSizeCheckTimer
{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

#pragma mark - Log Write To File

- (void)redirectNSlogToDocumentFolder
{
    if ([self.delegate respondsToSelector:@selector(logFileName)]) {
        NSString *name = [self.delegate logFileName];
        if (name) {
            self.currentLogFileName = name;
        }
    }
    if (self.currentLogFileName.length == 0) {
        [self deleteExpireLogFile];
        return;
    }
    NSString *path = [[self logFilePath] stringByAppendingPathComponent:self.currentLogFileName];
    NSString *header = [self logHeader];
    
    // 将log输入到文件
    freopen([path cStringUsingEncoding:NSASCIIStringEncoding],"a", stdout);
    freopen([path cStringUsingEncoding:NSASCIIStringEncoding],"a", stderr);
   
    NSLog(@"Begin\n%@", header);
    
    [self deleteExpireLogFile];
    
    if ([self.delegate respondsToSelector:@selector(startWriteLogToFile)]) {
        [self.delegate startWriteLogToFile];
   }
}

- (void)writeToEndOfFileWithLogString:(NSString *)log
{
#if DEBUG
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS +0800"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *string = [NSString stringWithFormat:@"%@ - %@\n", dateString, log];
    
    NSString *path = [[self logFilePath] stringByAppendingPathComponent:self.currentLogFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSString *logHeader = [self logHeader];
        [logHeader writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
#endif
}

#pragma mark - Log File

///log文件路径
-(NSString *)logFilePath
{
    NSString *logFilePath = [NSString stringWithFormat:@"%@/Logs", SCPathDocument];
    NSError *error = nil;
    SCFilePathCreate(logFilePath, error);
//    SCDebugLog(@"[Log] path = %@",logFilePath);
    if (error) {
//        SCLog(@"[Log][ERROR] %@",error);
    }
    return logFilePath;
}

-(NSArray *)logFilePaths
{
    NSString *file = [NSString stringWithFormat:@"%@/Logs", SCPathDocument];
    NSError *error = nil;
    NSArray *paths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:file error:&error];
    if (error) {
        SCLog(@"[log][ERROR] %@", error);
    }
    NSMutableArray *fullPaths = [[NSMutableArray alloc] init];
    for (NSString *name in paths) {
        [fullPaths addObject:[file stringByAppendingPathComponent:name]];
    }
    
    // 按时间给Log文件排序
    NSArray *sortArray = [fullPaths sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
        NSDictionary *att1 = [[NSFileManager defaultManager] attributesOfItemAtPath:obj1 error:nil];
        NSDictionary *att2 = [[NSFileManager defaultManager] attributesOfItemAtPath:obj2 error:nil];
        NSDate *cDate1 = nil;
        NSDate *cDate2 = nil;
        if ([att1 isKindOfClass:[NSDictionary class]] ) {
            cDate1 = att1[NSFileCreationDate];
        }
        if ([att2 isKindOfClass:[NSDictionary class]]) {
            cDate2 = att2[NSFileCreationDate];
        }
        if ([cDate1 isKindOfClass:[NSDate class]] && [cDate2 isKindOfClass:[NSDate class]]) {
            return [cDate1 compare:cDate2];
        }
        else if (cDate1 == nil) {
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    }];
    
    return sortArray;
}

///log文件名称
-(NSString *)currentLogFileName
{
    if (!_currentLogFileName) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHH +0800"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.log", [dateString substringToIndex:10]];
        _currentLogFileName = fileName;
    }
    return _currentLogFileName;
}

- (NSString *)currentLogFilePath
{
    NSString *path = [[self logFilePath] stringByAppendingPathComponent:self.currentLogFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return path;
    }
    return nil;
}

//删除过期log文件及压缩文件
-(void)deleteExpireLogFile
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *dateSortArray = [self logFilePaths];
        // 移除超出数量的Log
        if (self.maxLogFileCount > 0 && dateSortArray.count > self.maxLogFileCount) {
            NSArray *removeArray = [dateSortArray subarrayWithRange:NSMakeRange(0, dateSortArray.count-self.maxLogFileCount)];
            [removeArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[NSFileManager defaultManager] removeItemAtPath:obj error:nil];
            }];
        }
        for (NSInteger i=0; i<dateSortArray.count-1; i++) {
            NSString *subPath = dateSortArray[i];
            NSDictionary *atts = [[NSFileManager defaultManager] attributesOfItemAtPath:subPath error:nil];
            BOOL needRemove = YES;
            if ([atts isKindOfClass:NSDictionary.class]) {
                NSDate *createDate = [atts fileCreationDate];
                if (createDate) {
                    NSTimeInterval difftime = [[NSDate date] timeIntervalSinceDate:createDate];
                    if (difftime < self.logSaveDays*24*60*60) {
                        needRemove = NO;
                    }
                }
            }
            if (needRemove) {
                [[NSFileManager defaultManager] removeItemAtPath:subPath error:nil];
            }
            else {
                break;
            }
        }
    });
}

- (CGFloat)fileSizeWithPath:(NSString *)path
{
    NSError *error;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    unsigned long long size = [attributes[NSFileSize] unsignedLongLongValue];
    return (size/1024./1024.);
}

#pragma mark - 数据处理

/// log文件的初始数据
- (NSString *)logHeader
{
    return [NSString stringWithFormat:@"==================================================\n\n %@  \n==================================================\n ", [self mobileMessage]];
}

///log需要的设备信息
-(NSString *)mobileMessage
{
    NSString *message = [NSString stringWithFormat:@"Mobile : %@ \n System: %@ \n System Version: %@ \n App Version: %@(%@) \n", [UIDevice deviceMode], [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion, APPVersion, APPBuildVersion];
    if ([self.delegate respondsToSelector:@selector(logHeaderAppending)]) {
        message = [message stringByAppendingString:[self.delegate logHeaderAppending]];
    }
    return message;
}

@end
