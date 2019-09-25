//
//  SHHomeConfig.h
//  Robot
//
//  Created by 文堃 杜 on 2019/3/11.
//  Copyright © 2019 Haier. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    ///生产环境==0
    ProductEnv = 0,
    ///验收环境==1
    CheckEnv = 1,
    ///准生产环境==2
    PerProductEnv = 2,
} SHEnvirement;

// 环境配置
#define EnvirementTag [SHHomeConfig currentEnvirement]

NS_ASSUME_NONNULL_BEGIN

@interface SHHomeConfig : NSObject

/// 获取环境配置
+ (SHEnvirement)currentEnvirement;


+ (void)setCurrentEnvirement:(SHEnvirement )evirement;

#pragma mark - 个推

///个推APP id
+ (NSString *)gtAppId;
///个推APP key
+ (NSString *)gtAppKey;
///个推APP Secret
+ (NSString *)gtAppSecret;

@end

NS_ASSUME_NONNULL_END
