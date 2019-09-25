//
//  SHGlobalMacros.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/1.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#ifndef SHGlobalMacros_h
#define SHGlobalMacros_h

#import <Foundation/Foundation.h>


//云平台安住家庭的APP注册信息
#define ROBOT_APPID                 @"MB-ZNWG-0000"
#define ROBOT_APP_SECRET            @"23599ED05DC193F6FEB58DCAC74E2B7A"
#define ROBOT_APPKEY            @"47849bd0fd78f3dce63ac18746a9f20e"

#define HomeUserCenterClientId @"anzhu"
#define HomeUserCenterClientSecret @"B_d!WDVJbCTe2U"

#pragma mark - thrid library key
//高德地图
#define GenericApiKey @"e416534592ff4da4c340c7ef9eb99e45"


#pragma mark - Notification Name Define
///登录成功通知
#define LoginSuccessNotificationName @"LoginSuccessNotificationName"
///退出登录通知
#define LogoutSuccessNotificationName @"LogoutSuccessNotificationName"

/// 需要更新家庭信息  发送通知之后 SHHomeViewController 会调接口重新获取家庭信息
#define NeedUpdatedFamilyNotificationName @"NeedUpdatedFamilyNotificationName"
///绑定设备成功
#define BindDeviceSuccessNotificationName @"BindDeviceSuccessNotificationName"
///需要更新常用场景
#define NeedUpdateFrequentlyScenesNotificationName @"NeedUpdateFrequentlyScenesNotificationName"
///常用环境设置数据更新
#define WeatherConfigInfoUpdatedNotificationName @"WeatherConfigInfoUpdatedNotificationName"
/// 切换家庭或者获取家庭信息之后 都会发送这个通知
#define CurrentFamilyUpdatedNotificationName @"CurrentFamilyUpdatedNotificationName"
/// 有新的推送消息
#define kHaveNewMessageNotification @"kHaveNewMessageNotification"
/// 已进入消息列表，消息图标红点消失
#define kHadReadMessageListNotification @"kHadReadMessageListNotification"
//NAS清楚缓存
#define kNASClearCacheNotification @"kNASClearCacheNotification"
//涂鸦万能遥控器添加设备
#define kTuyaRemoteAddDeviceSuccess @"kTuyaRemoteAddDeviceSuccess"
//涂鸦万能遥控器自定义红外码编辑
#define kTuyaRemoteCustomizeInfoEditSuccess @"kTuyaRemoteCustomizeInfoEditSuccess"
//涂鸦万能遥控器自定义红外码新增
#define kTuyaRemoteCustomizeCodeAddSuccess @"kTuyaRemoteCustomizeCodeAddSuccess"

/////window显示的级别定义
//typedef enum : NSUInteger {
//    ///默认数值，与UIWindowLevelNormal值相同
//    SHWindowLevelNormal = 0,
//    ///设备迁移widow
////    SHWindowLevelDeviceTransfer = 10,
//    ///默认数值，与UIWindowLevelStatusBar值相同
//    SHWindowLevelStatusBar = 1000,
//    ///默认Alert弹出框数值，与UIWindowLevelAlert值相同
//    SHWindowLevelAlert = 2000,
//    ///隐私权弹窗
//    SHWindowLevelPrivacyPolicy = 2010,
//    ///升级提示
//    SHWindowLevelAPPNewVersionAlert = 2999,
//} SHWindowLevel;


#endif /* SHGlobalMacros_h */
