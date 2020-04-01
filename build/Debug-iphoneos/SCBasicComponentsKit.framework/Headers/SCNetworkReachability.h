//
//  SCNetworkReachability.h
//  SCBasicComponents_Example
//
//  Created by 文堃 杜 on 2019/11/2.
//  Copyright © 2019 wenkun. All rights reserved.
//


typedef enum : NSUInteger {
    SCDeviceNetWorkStatusNotReachable = 0,
    SCDeviceNetWorkStatusUnknown = 1,
    SCDeviceNetWorkStatusWWAN2G = 2,
    SCDeviceNetWorkStatusWWAN3G = 3,
    SCDeviceNetWorkStatusWWAN4G = 4,
    SCDeviceNetWorkStatusWiFi = 9,
} SCDeviceNetWorkStatus;

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *SCNetWorkReachabilityChangedNotification;

@interface SCNetworkReachability : NSObject

/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

- (BOOL)startNotifier;

- (void)stopNotifier;

- (SCDeviceNetWorkStatus)currentReachabilityStatus;

@end

NS_ASSUME_NONNULL_END
