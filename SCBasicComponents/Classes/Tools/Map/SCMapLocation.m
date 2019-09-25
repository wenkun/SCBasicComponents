//
//  SCMapLocation.m
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/2/14.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SCMapLocation.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "SCNetworking+Weather.h"


@interface SCMapLocation ()

@property (nonatomic, strong) AMapLocationManager *locationManager;
///当前定位信息获取状态
@property (nonatomic, assign) SCMapLocationRequestState locationRequestState;
///上一次获取的位置信息
@property (nonatomic, strong) SCMapLocationPoint *lastLocationPoint;
///上一次获取位置的时间
@property (nonatomic, strong) NSDate *lastPositioningDate;

@end

@implementation SCMapLocation


+(void)setGenericKey:(NSString *)key
{
    [AMapServices sharedServices].apiKey = key;
}

+(instancetype)share
{
    
    static SCMapLocation *mapLocation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapLocation = [[SCMapLocation alloc] init];
        SCDebugLog(@"AMapLocationKit Version = %@", AMapLocationVersion);
    });
    return mapLocation;
}
#pragma mark - 定位获取
-(AMapLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        _locationManager.locationTimeout = 3.;
        _locationManager.reGeocodeTimeout = 3.;
    }
    return _locationManager;
}

-(void)requestLocationAreaSuccess:(void (^)(SCMapLocationPoint *))success failed:(void (^)(NSError *))failed
{
    _locationRequestState = SCMapLocationRequestStatePositioning;
    __weak typeof(self) weakself = self;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            SCLog(@"[Generic][ERROR] %@",error);
            weakself.locationRequestState = SCMapLocationRequestStateFailed;
            SHSafeBlock(failed,error);
        }
        else {
            SCLog(@"[Generic] regeocode = %@", regeocode);
            weakself.locationRequestState = SCMapLocationRequestStateSuccess;
            SCMapLocationPoint *locPoint = [[SCMapLocationPoint alloc] init];
            locPoint.latitude = location.coordinate.latitude;
            locPoint.longitude = location.coordinate.longitude;
            locPoint.adcode = regeocode.adcode;
            locPoint.province = regeocode.province;
            locPoint.city = regeocode.city;
            locPoint.district = regeocode.district;
            weakself.lastLocationPoint = locPoint;
            weakself.lastPositioningDate = [NSDate date];
            SHSafeBlock(success,locPoint);
        }
    }];
}

-(void)stopRequestLocation
{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - 服务器基础数据

-(void)gainBasicAddressDataSuccess:(void (^)(void))successBlock failed:(void (^)(NSError *error))failed{
    if (self.basicAddressData.count>0) {
        SHSafeBlock(successBlock);
        return;
    }else{
        __weak typeof(self) weakSelf = self;
        [self downServerAddressDataSuccess:^(NSArray *responseDataArray) {
            weakSelf.basicAddressData = [SHBasicAdressItemModle analyzingWithArrayData:responseDataArray];
            SHSafeBlock(successBlock);
        } failed:^(NSError *error) {
            SHSafeBlock(failed,error);
        }];
    }
}
- (void)downServerAddressDataSuccess:(void (^)(NSArray *responseDataArray))successBlock failed:(void (^)(NSError *error))failed{
        NSString *path = [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:@"serverAddressData.plist"];
    [SCNetworking gainChinaLocationInfoSuccess:^(NSDictionary *responseDictionary) {
        NSArray *resDataArrar = responseDictionary[@"data"][@"locationInfos"];
        SHSafeBlock(successBlock,resDataArrar);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (resDataArrar.count>0&&[resDataArrar writeToFile:path atomically:YES]) {
                SCDebugLog(@"\n【地址数据】基础地址数据保存成功：%@",path);
            }
        });
    } failed:^(NSError *error) {
        SHSafeBlock(failed,error);
        SCDebugLog(@"\n【地址数据】基础地址数据获取失败：%@",error.localizedDescription);
    }];
}
- (NSString *)basicAddressDataSavePath{
//    NSString *path = [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:@"basicAddressData.plist"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"basicAddressData" ofType:@"plist"];
    SCDebugLog(@"\n【地址数据】地址数据本地保存路径：%@\n",path);
    return path;
}
- (void)gainServerAdcodeWithMapLocationPoint:(SCMapLocationPoint *)mapLocationPoint success:(void (^)(NSString *adcode))successBlock failed:(void (^)(NSError *error))failed{
    NSError *notFindError = [NSError errorWithDomain:@"SCMapLocation" code:-11111 description:@"没有找到对应的定位城市"];
    if (!mapLocationPoint) SHSafeBlock(failed,notFindError);
    __weak typeof(self) weakself = self;
    [self gainBasicAddressDataSuccess:^{
        SHBasicAdressItemModle *localAddressModel = nil;
        NSString *code = nil;
        NSString *province = mapLocationPoint.province;
        NSString *city = mapLocationPoint.city;
        NSString *area = mapLocationPoint.district;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ CONTAINS[cd] SELF.provcn AND %@ CONTAINS[cd] SELF.districtcn", province,city];
        NSArray *sameCityArea = [weakself.basicAddressData filteredArrayUsingPredicate:predicate];
        
        NSPredicate *predicateArea = [NSPredicate predicateWithFormat:@"%@ CONTAINS[cd] SELF.namecn", area];
        NSArray *usefullCitys = [sameCityArea filteredArrayUsingPredicate:predicateArea];
        if (usefullCitys.count>0) {
            localAddressModel = usefullCitys.firstObject;
        }
        
        if (!localAddressModel) {//没有在本地找到最精确的那一个，则去离之最近的城市
            localAddressModel = sameCityArea.firstObject;
        }
        code = localAddressModel.areaid.stringValue;
        SCDebugLog(@"\n定位数据\n%@对应的本地数据:\n%@",mapLocationPoint.descDictionary,localAddressModel.descDictionary);
//        NSAssert(code, @"本地数据库没有找到对应的定位城市");
        if (code) {
            SHSafeBlock(successBlock,code);
        }else{
            SHSafeBlock(failed,notFindError);
        }
    } failed:^(NSError *error) {
        SHSafeBlock(failed,error);
    }];
}

/**
 根据地址代码获取对应的城市信息
 
 @param addressCode 地址代码
 @param successBlock 成功
 @param failed 失败
 */
- (void)locationWithAddressCode:(NSString *)addressCode success:(void (^)(SHBasicAdressItemModle *addressModel))successBlock failed:(void (^)(NSError *error))failed{
    NSError *notFindError = [NSError errorWithDomain:@"SCMapLocation" code:-11111 description:@"地址代码有误或者没有找到对应的城市"];
    SHSafeBlock(failed,notFindError);
    __weak typeof(self) weakself = self;
    [self gainBasicAddressDataSuccess:^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.areaid == %@",addressCode.numberValue];
        NSArray *result = [weakself.basicAddressData filteredArrayUsingPredicate:predicate];
        SHBasicAdressItemModle *model = nil;
        if (result.count>0) {
            model = result.firstObject;
        }
        if (model) {
            SHSafeBlock(successBlock,model);
        }else{
            SHSafeBlock(failed,notFindError);
        }
//        NSAssert(model, @"地址代码没有找到对应的城市");
    } failed:^(NSError *error) {
        SHSafeBlock(failed,error);
    }];
}

#pragma mark - property
- (NSArray<SHBasicAdressItemModle *> *)basicAddressData{
    if (!_basicAddressData) {
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        NSString *localPath = [self basicAddressDataSavePath];
        if ([defaultManager fileExistsAtPath:localPath]) {
            NSArray *localArrar = [NSArray arrayWithContentsOfFile:localPath];
            _basicAddressData = [SHBasicAdressItemModle analyzingWithArrayData:localArrar];
            SCDebugLog(@"\n【地址数据】地址数据从本地获取成功：%@",localPath);
        }
    }
    return _basicAddressData;
}
-(SHBasicAdressItemModle *)defaultAdressItemModle{
    if (!_defaultAdressItemModle) {
       NSDictionary *dic = @{
                             @"counen" : @"china",
                             @"country" : @"中国",
                             @"stationType" : @"城市",
                             @"provcn" : @"山东",
                             @"longitude" : @120.58491,
                             @"latitude" : @36.19559,
                             @"nameen" : @"laoshan",
                             @"districtcn" : @"青岛",
                             @"areaid" : @101120202,
                             @"namecn" : @"崂山",
                             @"proven" : @"shandong",
                             @"districten" : @"qingdao",
                             };
        _defaultAdressItemModle = [[SHBasicAdressItemModle alloc] initWithData:dic];
    }
    return _defaultAdressItemModle;
}
@end
