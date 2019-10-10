//
//  UIDevice+SCExtension.h
//  SCBasicComponents_Example
//
//  Created by 文堃 杜 on 2018/2/11.
//  Copyright © 2018年 wenkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SCExtension)
/// Whether the device is a simulator.
@property (nonatomic, readonly) BOOL isSimulator;
/**
 获取设备型号，例如：iPhone 7

 @return 设备型号
 */
+ (NSString *)deviceMode;
/**
 获取当前连接的wifi名字
 
 @return 当前的WiFi名字
 */
+ (NSString *)currentSSID;
/**
 获取当前连接WiFi的mac
 
 @return 当前WiFi的mac
 */
+(NSString *)currentBSSID;
@end