//
//  SCModel.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/2/28.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 此为Model父类，提供方法将NSDictionary数据自动赋值到Model对应的属性。
 使用要求：Model属性名与Dictionary的可Key值完全相同。个别例外情况：如果Key值为‘id’时，Model属性名应改为‘id_’才能匹配成功。
 */
@interface SCModel : NSObject

///初始化
-(instancetype)initWithData:(NSDictionary *)data;
///解析数据
-(void)configData:(NSDictionary *)data;
///数组数据解析，
+(NSArray *)analyzingWithArrayData:(NSArray *)data;
///转化为字典，支持的属性类型包括：NSString,NSNumber,NSArray,NSDictionary,SCModel
-(NSDictionary *)descDictionary;

@end


@interface NSArray (SCModel)

///根据成员变量的Class解析数组数据
+(NSArray *)analyzingWithArrayData:(NSArray *)data withMenberClass:(Class)cla;

@end
