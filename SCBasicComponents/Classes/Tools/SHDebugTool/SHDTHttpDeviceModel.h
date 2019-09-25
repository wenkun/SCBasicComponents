//
//  SHDTHttpDeviceModel.h
//  Robot
//
//  Created by 星星 on 2018/8/6.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SCModel.h"

@interface SHDTHttpDeviceModel : SCModel
///
@property (copy, nonatomic) NSString *deviceId;
///
@property (copy, nonatomic) NSNumber *online;
///
@property (copy, nonatomic) NSString *deviceName;
///
@property (copy, nonatomic) NSString *deviceType;
///
@property (copy, nonatomic) NSString *wifiType;


@end
