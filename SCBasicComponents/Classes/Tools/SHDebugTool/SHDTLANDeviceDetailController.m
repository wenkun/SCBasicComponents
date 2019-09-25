//
//  SHDTLANDeviceDetailController.m
//  Robot
//
//  Created by 星星 on 2018/7/11.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SuSDKDeviceDataTransfer.h"
#import <uSDK/uSDK.h>

#pragma mark - SHDebugDevice

@interface SHDebugDevice : NSObject

@property (nonatomic, strong) NSMutableAttributedString *logText;
@property (nonatomic, copy) void(^ hadNewMessage)(NSMutableAttributedString *logText);
@property (nonatomic, assign) int count;

@end

@implementation SHDebugDevice

- (NSMutableAttributedString *)logText
{
    if (!_logText) {
        _logText = [[NSMutableAttributedString alloc] init];
    }
    return _logText;
}

- (void)receivedDeviceAttributeUpdate:(NSNotification *)not
{
    uSDKDevice *dev = not.object;
    NSMutableArray *attArray = [[NSMutableArray alloc] init];
    for (uSDKDeviceAttribute *att in dev.attributeDict.allValues) {
        [attArray addObject:@{att.attrName: att.attrValue}];
    }
    
    [self.logText appendAttributedString:[[NSAttributedString alloc] initWithString:[self splitterString] attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}]];
    
    NSMutableString *log = [NSMutableString stringWithFormat:@"\n"];
    [self.logText appendAttributedString:[[NSAttributedString alloc] initWithString:log attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}]];
    log = [NSMutableString string];
    
    [self subDeviceSpecialLogSetting];
    
    [attArray sortUsingComparator:^NSComparisonResult(NSDictionary * _Nonnull obj1, NSDictionary * _Nonnull obj2) {
        return [obj1.allKeys.firstObject compare:obj2.allKeys.firstObject];
    }];
    for (NSDictionary *dic in attArray) {
        [log appendFormat:@" [%@] : %@ \n", dic.allKeys.firstObject, dic.allValues.firstObject];
    }
    
    [self.logText appendAttributedString:[[NSAttributedString alloc] initWithString:log attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}]];
    
    SCSafeBlock(self.hadNewMessage, self.logText);
}

- (void)subDeviceSpecialLogSetting
{
    
}

- (void)receivedDeviceAlarmUpdate:(NSNotification *)not
{
    uSDKDevice *dev = not.object;
//    if ([self.macArray containsObject:dev.mac]) {
        NSMutableString *log = [NSMutableString string];
        for (uSDKDeviceAlarm *alarm in dev.alarmList) {
            [log appendFormat:@"  %@ \n", alarm.name];
        }
        [self.logText appendAttributedString:[[NSAttributedString alloc] initWithString:[self splitterString] attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
        [self.logText appendAttributedString:[[NSAttributedString alloc] initWithString:log attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
        
        SCSafeBlock(self.hadNewMessage, self.logText);
//    }
}

- (void)receivedDeviceStateUpdate:(NSNotification *)not
{
    uSDKDevice *dev = not.object;
//    if ([self.macArray containsObject:dev.mac]) {
        [self.logText appendAttributedString:[[NSAttributedString alloc] initWithString:[self splitterString] attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}]];
        [self.logText appendAttributedString:[[NSAttributedString alloc] initWithString:[SHDebugDevice state:dev.state] attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}]];
        
        SCSafeBlock(self.hadNewMessage, self.logText);
//    }
}

- (NSString *)splitterString
{
    self.count ++;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd hh:mm:ss +0800"];
    return [NSString stringWithFormat:@"\n [%ld] ====================== %@ \n", self.count, [dateFormatter stringFromDate:[NSDate date]]];
}

+ (NSString *)state:(NSUInteger)index
{
    NSArray *array = @[@"未连接", @"离线", @"连接中", @"连接成功", @"就绪"];
    return array[index];
}

@end


#pragma mark - SHDebugS70Lock

@interface SHDebugS70Lock : SHDebugDevice
@end

@implementation SHDebugS70Lock

- (void)receivedDeviceAttributeUpdate:(NSNotification *)not
{
    uSDKDevice *dev = not.object;
    NSMutableArray *attArray = [[NSMutableArray alloc] init];
    NSDictionary *attDic = [[NSMutableDictionary alloc] init];
    for (uSDKDeviceAttribute *att in dev.attributeDict.allValues) {
        if (att.attrName.length > 1) {
            NSInteger index = [[att.attrName substringFromIndex:att.attrName.length-1] integerValue];
            if (index == 1) {
                [attArray addObject:@{att.attrName: att.attrValue}];
                [attDic setValue:att.attrValue forKey:att.attrName];
            }
        }
    }
    
    [self.logText appendAttributedString:[[NSAttributedString alloc] initWithString:[self splitterString] attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}]];
    
    NSMutableString *log = [NSMutableString stringWithFormat:@"\n"];
    [self.logText appendAttributedString:[[NSAttributedString alloc] initWithString:log attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}]];
    log = [NSMutableString string];
    
    [log appendFormat:@"【网关：%@】 >> 【门锁：%@】 \t【haier_onlineStatus1 : %@】\n", [SHDebugDevice state:dev.state], [attDic[@"haier_onlineStatus1"] boolValue]?@"在线":@"离线", attDic[@"haier_onlineStatus1"]];
    [self.logText appendAttributedString:[[NSAttributedString alloc] initWithString:log attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}]];
    log = [NSMutableString string];
    
    int v = [attDic[@"Protocolver1"] intValue];
    int v4 = v%32;
    v = (v >> 5);
    int v3 = v%8;
    v = (v >> 3);
    int v2 = v%16;
    v = (v >> 4);
    int v1 = v;
    [log appendFormat:@"型号：%d \t 版本：%d - %d \t 消息源：%d-%d \t 【Protocolver1:%@】\n", v4, v1, v2, v3>>1, v3%2, attDic[@"Protocolver1"]];
    [log appendFormat:@"【Protocolver2：%@】【Protocolver3：%@】【Protocolver4：%@】【Protocolver5：%@】\n", dev.attributeDict[@"Protocolver2"].attrValue, dev.attributeDict[@"Protocolver3"].attrValue, dev.attributeDict[@"Protocolver4"].attrValue, dev.attributeDict[@"Protocolver5"].attrValue];
    
    [log appendFormat:@"开关门：\n"];
    [log appendFormat:@"   %@ haier_lockcontrol1 : %@\n", [attDic[@"haier_lockcontrol1"] boolValue]?@"开":@"关", attDic[@"haier_lockcontrol1"]];
    [log appendFormat:@"   %@ haier_allopen1 : %@\n", [attDic[@"haier_allopen1"] boolValue]?@"关":@"开", attDic[@"haier_allopen1"]];
    [log appendFormat:@"   方舌%@ haier_Statetongue1 : %@\n", [attDic[@"haier_Statetongue1"] boolValue]?@"开":@"关", attDic[@"haier_Statetongue1"]];
    [log appendFormat:@"   斜舌%@ haier_Latchstate1 : %@\n", [attDic[@"haier_Latchstate1"] boolValue]?@"开":@"关", attDic[@"haier_Latchstate1"]];
    
    int p = [attDic[@"haier_Record1"] intValue];
    if (p != 0) {
        [log appendFormat:@"操作：%x %@ \n", p, [self getTypeDescriptionBystring:[NSString stringWithFormat:@"%x", p/0xff]]];
    }
    
    [log appendFormat:@"电量：%@ 【haier_batterysoc1:%@】\n", attDic[@"haier_batterysoc1"], attDic[@"haier_batterysoc1"]];
    
    [attArray sortUsingComparator:^NSComparisonResult(NSDictionary * _Nonnull obj1, NSDictionary * _Nonnull obj2) {
        return [obj1.allKeys.firstObject compare:obj2.allKeys.firstObject];
    }];
    [log appendFormat:@"\n"];
    for (NSDictionary *dic in attArray) {
        [log appendFormat:@" %@:%@ \n", dic.allKeys.firstObject, dic.allValues.firstObject];
    }
    
    [self.logText appendAttributedString:[[NSAttributedString alloc] initWithString:log attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}]];
    
    SCSafeBlock(self.hadNewMessage, self.logText);
}

- (NSString *)getTypeDescriptionBystring:(NSString *)type {
    NSString *typeDescription;
    NSDictionary *dic = @{@"80":@"添加卡片记录",
                          @"81":@"添加密码记录",
                          @"82":@"添加指纹记录",
                          @"83":@"添加管理记录",
                          @"84":@"删除卡片记录",
                          @"85":@"删除密码记录",
                          @"86":@"删除指纹记录",
                          @"87":@"删除管理记录",
                          @"88":@"修改卡片记录",
                          @"89":@"修改密码记录",
                          @"8A":@"修改指纹记录",
                          @"8B":@"修改管理员密码记录",
                          @"8C":@"全部删除卡片",
                          @"8D":@"全部删除密码",
                          @"8E":@"全部删除指纹",
                          @"00":@"无修改记录正常上报"};
    if (dic[type]) {
        typeDescription = dic[type];
    }else {
        typeDescription = @"没有操作";
    }
    
    return typeDescription;
}

@end

#pragma mark - SHDeviceDebug

@interface SHDeviceDebugManager : NSObject
@property (nonatomic, strong) NSMutableDictionary *devices;
@end
@implementation SHDeviceDebugManager
#if uSDK_DEBUG
+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserver:[SHDeviceDebugManager single] selector:@selector(receivedDeviceAttributeUpdate:) name:SCuSDKDeviceAttritubeUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[SHDeviceDebugManager single] selector:@selector(receivedDeviceAlarmUpdate:) name:SCuSDKDeviceAlarmUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[SHDeviceDebugManager single] selector:@selector(receivedDeviceStateUpdate:) name:SCuSDKDeviceStateUpdateNotification object:nil];
}
#endif
+ (SHDeviceDebugManager *)single
{
    static SHDeviceDebugManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @synchronized(self) {
            instance = [[SHDeviceDebugManager alloc] init];
        }
    });
    return instance;
}
- (NSMutableDictionary *)devices
{
    if (!_devices) {
        _devices = [[NSMutableDictionary alloc] init];
    }
    return _devices;
}
- (SHDebugDevice *)s70LockWithuSDKDevice:(uSDKDevice *)dev
{
    SHDebugDevice *lock = [self.devices objectForKey:dev.mac];
    if (!lock) {
        if ([dev.uplusID isEqualToString:@"201c80c70c50031c1102e4b10d06924de1158d66e6e5b852931d670f6c0b1740"]) {
            lock = [[SHDebugS70Lock alloc] init];
        }
        else {
            lock = [[SHDebugDevice alloc] init];
        }
        [self.devices setObject:lock forKey:dev.mac];
    }
    return lock;
}
- (void)receivedDeviceAttributeUpdate:(NSNotification *)not
{
    uSDKDevice *dev = not.object;
    SHDebugDevice *lock = [self s70LockWithuSDKDevice:dev];
    [lock receivedDeviceAttributeUpdate:not];
}
- (void)receivedDeviceAlarmUpdate:(NSNotification *)not
{
    uSDKDevice *dev = not.object;
    SHDebugDevice *lock = [self s70LockWithuSDKDevice:dev];
    [lock receivedDeviceAlarmUpdate:not];
}
- (void)receivedDeviceStateUpdate:(NSNotification *)not
{
    uSDKDevice *dev = not.object;
    SHDebugDevice *lock = [self s70LockWithuSDKDevice:dev];
    [lock receivedDeviceStateUpdate:not];
}
@end

#pragma mark - ViewController

#import "SHDTLANDeviceDetailController.h"

@interface SHDTLANDeviceDetailController ()
@property (weak, nonatomic) IBOutlet UITextView *mTextView;
///
@property (strong, nonatomic) NSTimer *timer;

#if uSDK_DEBUG
@property (nonatomic, strong) SHDebugDevice *debugLock;
#endif
@end

@implementation SHDTLANDeviceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
#if uSDK_DEBUG
    SHDebugDevice *lock = [[SHDeviceDebugManager single].devices objectForKey:self.uDevice.mac];
    if (lock) {
        self.debugLock = lock;
        [self.mTextView setAttributedText:lock.logText];
        [self.mTextView scrollRangeToVisible:NSMakeRange(self.mTextView.text.length-2, 1)];
        lock.hadNewMessage = ^(NSMutableAttributedString *logText) {
            [self.mTextView setAttributedText:logText];
        };
    }
    else {
        [self update];
        [self startDeviceStatusUpdateTimer];
    }
#else
    [self update];
    [self startDeviceStatusUpdateTimer];
#endif
    // Do any additional setup after loading the view from its nib.
}
- (void)dealloc{
    [self endDeviceStatusUpdateTimer];
}

- (void)update{
    NSString *descr = _uDevice.description;
    NSString *att = _uDevice.attributeDict.description ;
    _mTextView.text = [NSString stringWithFormat:@"%@\n%@",descr,att];
}
- (void)startDeviceStatusUpdateTimer{
    if (!_timer||![_timer isValid]) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
- (void)endDeviceStatusUpdateTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
