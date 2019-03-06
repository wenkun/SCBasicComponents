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
@property (nonatomic, strong) NSString *logFileName;

@end

@implementation SCLogManager

#pragma mark - Life Cycle

+(instancetype)share
{
    static SCLogManager *timerManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timerManager = [[SCLogManager alloc] init];
    });
    return timerManager;
}

-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Interface

+(void)logWithFormat:(NSString *)format, ...
{
    va_list ap;
    va_start (ap, format);
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end (ap);
    
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

+(void)startLogAndWriteToFile
{
    [[SCLogManager share] redirectNSlogToDocumentFolder];
//    SCLog(@"\n==================================================\n\n \t\t iOS LOG BEGIN \n\n  %@  \n==================================================\n ", [SCLogManager mobileMessage]);
}

#pragma mark - Log Write To File

- (void)redirectNSlogToDocumentFolder
{
    [self deleteExpireLogFile];
    
    if ([self.delegate respondsToSelector:@selector(logFileName)]) {
        self.logFileName = [self.delegate logFileName];
    }
    NSString *path = [[self logFilePath] stringByAppendingPathComponent:self.logFileName];
    NSString *header = [NSString stringWithFormat:@"==================================================\n\n %@  \n==================================================\n ", [self mobileMessage]];
    [header writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // 将log输入到文件
    freopen([path cStringUsingEncoding:NSASCIIStringEncoding],"a", stdout);
    freopen([path cStringUsingEncoding:NSASCIIStringEncoding],"a", stderr);
}

#pragma mark - Log File

///log文件路径
-(NSString *)logFilePath
{
    NSString *logFilePath = [NSString stringWithFormat:@"%@/Logs", SCPathDocument];
    NSError *error = nil;
    SCFilePathCreate(logFilePath, error);
    SCDebugLog(@"[Log] path = %@",logFilePath);
    if (error) {
        SCLog(@"[Log][ERROR] %@",error);
    }
    return logFilePath;
}

-(NSArray *)logFilePaths
{
    NSString *file = [NSString stringWithFormat:@"%@/Logs", SCPathDocument];
    NSError *error = nil;
    NSArray *paths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:file error:&error];
    paths = [paths sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *fullPaths = [[NSMutableArray alloc] init];
    for (NSString *name in paths) {
        [fullPaths addObject:[file stringByAppendingPathComponent:name]];
    }
    if (error) {
        SCLog(@"[log][ERROR] %@", error);
    }
    return fullPaths;
}

///log文件名称
-(NSString *)logFileName
{
    if (!_logFileName) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd +0800"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.log", [dateString substringToIndex:10]];
        _logFileName = fileName;
    }
    return _logFileName;
}

//删除过期log文件及压缩文件
-(void)deleteExpireLogFile
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = self.logFilePath;
        NSArray *array = [[NSFileManager defaultManager] subpathsAtPath:path];
        for (NSString *subPath in array) {
            if (subPath.length == 18) {
                NSString *fDateStr = [subPath substringWithRange:NSMakeRange(4, 10)];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd +0800"];
                NSDate *fDate = [dateFormatter dateFromString:[fDateStr stringByAppendingString:@" +0800"]];
                NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:fDate];
                if (interval > 60*60*24*self.logSaveDays) {
                    [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:subPath] error:nil];
                }
            }
        }
    });
}

#pragma mark - 数据处理

///log需要的设备信息
-(NSString *)mobileMessage
{
    NSString *message = [NSString stringWithFormat:@"Mobile : %@ \n System: %@ \n System Version: %@ \n App Version: %@(%@) \n", [UIDevice deviceMode], [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion, APPVersion, APPBuildVersion];
    if ([self.delegate respondsToSelector:@selector(logHeaderAppending)]) {
        message = [message stringByAppendingString:[self.delegate logHeaderAppending]];
    }
    return message;
}

#pragma mark - Notification

-(void)appWillEnterForground:(NSNotification *)not
{
#if SCLogWriteToFile
    //比较当前时间与log文件的创建文件的日期，如果不同重新创建文件写入
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd +0800"];
    NSString *currentDate = [[dateFormatter stringFromDate:[NSDate date]] substringToIndex:10];
    NSString *fileDate = [self.logFileName substringWithRange:NSMakeRange(4, 10)];
    if (![currentDate isEqualToString:fileDate]) {
        self.logFileName = nil;
        [SCLogManager startLogAndWriteToFile];
    }
#endif
}

@end
