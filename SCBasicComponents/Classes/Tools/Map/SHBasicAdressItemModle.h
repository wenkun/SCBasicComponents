//
//  SHBasicAdressItemModle.h
//  Robot
//
//  Created by 星星 on 2018/6/8.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SCModel.h"

/**
 服务器地址 model
 */
@interface SHBasicAdressItemModle : SCModel
///城市code
@property (copy, nonatomic) NSNumber *areaid;
///国家英文名字
@property (copy, nonatomic) NSString *counen;
///国家中文名字
@property (copy, nonatomic) NSString *country;
///类型
@property (copy, nonatomic) NSString *stationType;
///省中文名
@property (copy, nonatomic) NSString *provcn;
///省英文名
@property (copy, nonatomic) NSString *proven;
///区域英文名
@property (copy, nonatomic) NSString *nameen;
///区域中文名
@property (copy, nonatomic) NSString *namecn;
///市中文名
@property (copy, nonatomic) NSString *districtcn;
///市英文名
@property (copy, nonatomic) NSString *districten;
///经度
@property (strong, nonatomic) NSNumber *longitude;
///纬度
@property (strong, nonatomic) NSNumber *latitude;

@end
