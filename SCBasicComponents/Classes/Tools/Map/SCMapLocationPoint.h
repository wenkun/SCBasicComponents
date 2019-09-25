//
//  SCMapLocationPoint.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/2/22.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCMapLocationPoint : SCModel

///纬度
@property (nonatomic, assign) CGFloat latitude;
///经度
@property (nonatomic, assign) CGFloat longitude;

///区域编码
@property (nonatomic, copy) NSString *adcode;
///省份
@property (nonatomic, copy) NSString *province;
///城市
@property (nonatomic, copy) NSString *city;
///区
@property (nonatomic, copy) NSString *district;

@end
