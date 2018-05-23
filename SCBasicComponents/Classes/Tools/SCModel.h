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
 使用要求：Model属性名与Dictionary的可Key值完全相同。个别例外情况：
            ① 如果Key值为‘id’等不支持设置为属性名称的单词时，默认将Model属性名应改为‘id_’才能匹配成功。
            ② 其他需要自定义的属性名称，可重写specialPropertyReplaceForm方法设置model的property与字典的key的对应关系。
            ③ 前面两种情况可同时支持，②的优先级高于①
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
///对于有特殊字符数据key值或者有特殊要求的属性，可重写此方法来自定义key值与属性的对应关系，不需要key值与属性名称完全相同。其中返回的NSDictionary中的key为属性名称，value为对应数据中的key值。
-(NSDictionary *)specialPropertyReplaceForm;

@end


@interface NSArray (SCModel)

///根据成员变量的Class解析数组数据
+(NSArray *)analyzingWithArrayData:(NSArray *)data withMenberClass:(Class)cla;

@end
