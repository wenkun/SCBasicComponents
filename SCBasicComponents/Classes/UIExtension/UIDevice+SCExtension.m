//
//  UIDevice+SCExtension.m
//  SCBasicComponents_Example
//
//  Created by 文堃 杜 on 2018/2/11.
//  Copyright © 2018年 wenkun. All rights reserved.
//

#import "UIDevice+SCExtension.h"
#import "sys/utsname.h"
#import <SystemConfiguration/CaptiveNetwork.h>
@implementation UIDevice (SCExtension)

- (BOOL)isSimulator {
    static dispatch_once_t one;
    static BOOL simu;
    dispatch_once(&one, ^{
        simu = NSNotFound != [[self model] rangeOfString:@"Simulator"].location;
    });
    return simu;
}

+ (NSString *)deviceMode
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iphone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS MAX";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    //ipod
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPod Touch 6";
    //ipad
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,7"])  return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,8"])  return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,8"])  return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,9"])  return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,2"])  return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,3"])  return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])  return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])  return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,4"])  return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,7"])  return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,8"])  return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,11"])  return @"iPad 5";
    if ([platform isEqualToString:@"iPad6,12"])  return @"iPad 5";
    if ([platform isEqualToString:@"iPad7,1"])  return @"iPad Pro 2(12.9-inch)";
    if ([platform isEqualToString:@"iPad7,2"])  return @"iPad Pro 2(12.9-inch)";
    if ([platform isEqualToString:@"iPad7,3"])  return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad7,4"])  return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad7,5"])  return @"iPad 6";
    if ([platform isEqualToString:@"iPad7,6"])  return @"iPad 6";
    if ([platform isEqualToString:@"iPad8,1"])  return @"iPad Pro (11-inch) ";
    if ([platform isEqualToString:@"iPad8,2"])  return @"iPad Pro (11-inch) ";
    if ([platform isEqualToString:@"iPad8,3"])  return @"iPad Pro (11-inch) ";
    if ([platform isEqualToString:@"iPad8,4"])  return @"iPad Pro (11-inch) ";
    if ([platform isEqualToString:@"iPad8,5"])  return @"iPad Pro 3 (12.9-inch) ";
    if ([platform isEqualToString:@"iPad8,6"])  return @"iPad Pro 3 (12.9-inch) ";
    if ([platform isEqualToString:@"iPad8,7"])  return @"iPad Pro 3 (12.9-inch) ";
    if ([platform isEqualToString:@"iPad8,8"])  return @"iPad Pro 3 (12.9-inch) ";
    //simulator
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    return platform;
}

/**
 获取当前连接的wifi名字
 
 @return 当前的WiFi名字
 */
+ (NSString *)currentSSID
{
    NSDictionary *info = [[self class] currentWiFiInfo];
    NSString *ssid = nil;
    if (info && info[@"SSID"]) {
        ssid = [NSString stringWithFormat:@"%@", [info objectForKey:@"SSID"]];
    }
    return ssid;
}

/**
 获取当前连接WiFi的mac
 
 @return 当前WiFi的mac
 */
+(NSString *)currentBSSID
{
    NSDictionary *info = [[self class] currentWiFiInfo];
    NSString *bssid = nil;
    if (info && info[@"BSSID"]) {
        bssid = [NSString stringWithFormat:@"%@", [info objectForKey:@"BSSID"]];
    }
    return bssid;
}

+ (NSDictionary *)currentWiFiInfo
{
    NSDictionary *info = nil;
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *a = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (a && [a count]) {
            info = [[NSDictionary alloc] initWithDictionary:a];
            CFRelease((__bridge CFTypeRef)(a));
            break;
        }
        if (a) {
            CFRelease((__bridge CFTypeRef)(a));
        }
    }
    CFRelease((__bridge CFTypeRef)(ifs));
    return info;
}

@end
