//
//  SCMapLocation.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/2/14.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SCMapLocationPoint.h"
#import "SHBasicAdressItemModle.h"

///当前定位信息获取状态
typedef enum : NSUInteger {
    ///未开始定位
    SCMapLocationRequestStateNone,
    ///正在获取位置信息
    SCMapLocationRequestStatePositioning,
    ///获取位置信息成功
    SCMapLocationRequestStateSuccess,
    ////获取位置信息失败
    SCMapLocationRequestStateFailed,
} SCMapLocationRequestState;

@interface SCMapLocation : NSObject

///设置高德地图的apiKey
+(void)setGenericKey:(NSString *)key;

///单例
+(instancetype)share;
///所有省市区（包括国外）的位置信息
@property (strong, nonatomic) NSArray<SHBasicAdressItemModle *> *basicAddressData;
///当前定位信息获取状态
@property (nonatomic, readonly) SCMapLocationRequestState locationRequestState;
///上一次获取的位置信息
@property (nonatomic, readonly) SCMapLocationPoint *lastLocationPoint;
///上一次获取位置的时间
@property (nonatomic, readonly) NSDate *lastPositioningDate;
///默认天气城市
@property (strong, nonatomic) SHBasicAdressItemModle *defaultAdressItemModle;
///获取当前位置的城市信息
-(void)requestLocationAreaSuccess:(void (^)(SCMapLocationPoint *locPoint))success failed:(void (^)(NSError *error))failed;
///停止当前位置信息获取
-(void)stopRequestLocation;

/**
 下载服务器地址数据会存储的本地

 @param successBlock 成功
 @param failed 失败
 */
- (void)downServerAddressDataSuccess:(void (^)(NSArray *responseDataArray))successBlock failed:(void (^)(NSError *error))failed;
/**
 获取服务器地址数据，第一次获取之后会存储到本地

 @param successBlock 成功
 @param failed 失败
 */
-(void)gainBasicAddressDataSuccess:(void (^)(void))successBlock failed:(void (^)(NSError *error))failed;

/**
 将定位数据转为 天气城市code

 @param mapLocationPoint 高德地图定位结果
 @param successBlock 成功
 @param failed 失败
 */
- (void)gainServerAdcodeWithMapLocationPoint:(SCMapLocationPoint *)mapLocationPoint success:(void (^)(NSString *adcode))successBlock failed:(void (^)(NSError *error))failed;

/**
 根据地址代码获取对应的城市信息

 @param addressCode 地址代码
 @param successBlock 成功
 @param failed 失败
 */
- (void)locationWithAddressCode:(NSString *)addressCode success:(void (^)(SHBasicAdressItemModle *addressModel))successBlock failed:(void (^)(NSError *error))failed;
@end
