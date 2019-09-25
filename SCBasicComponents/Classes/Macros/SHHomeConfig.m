//
//  SHHomeConfig.m
//  Robot
//
//  Created by 文堃 杜 on 2019/3/11.
//  Copyright © 2019 Haier. All rights reserved.
//

#import "SHHomeConfig.h"

/* 个推 */
NSString const * GTAppId_dev = @"gjMJj7tdatAUwTzmlzeTv1";
NSString const * GTAppKey_dev = @"ApPtBG3waB6xlIq8uB3sl8";
NSString const * GTAppSecret_dev = @"wz0hhnsx4F6prijojYE5x1";

NSString const * GTAppId = @"7d4OpZDpKf7TAhp5F0jL49";
NSString const * GTAppKey = @"uOHwXDVxf3AzmGalWhJ0N";
NSString const * GTAppSecret = @"LFlLY3NbBaARLxnd4jRC68";

@implementation SHHomeConfig

+ (SHEnvirement)currentEnvirement
{
    static SHEnvirement currentEvn = 0;
    static NSString *evn = nil;
    if (evn == nil) {
        evn = [[NSUserDefaults standardUserDefaults] stringForKey:@"Envirement_preference"];
        if (evn == nil) evn = @"18884";
        if ([evn isEqualToString:@"18888"]) {
            currentEvn = CheckEnv;
        }
        else if ([evn isEqualToString:@"18889"]) {
            currentEvn = PerProductEnv;
        }
        else {
            currentEvn = ProductEnv;
        }
    }
    return currentEvn;
}
+ (void)setCurrentEnvirement:(SHEnvirement )evirement{
    
    if (CheckEnv == evirement) {
        [[NSUserDefaults standardUserDefaults] setObject:@"18888" forKey:@"Envirement_preference"];
    }else if (PerProductEnv == evirement){
        [[NSUserDefaults standardUserDefaults] setObject:@"18889" forKey:@"Envirement_preference"];
    }else if (ProductEnv == evirement){
        [[NSUserDefaults standardUserDefaults] setObject:@"18884" forKey:@"Envirement_preference"];
    }
    
}
#pragma mark - 个推

///个推APP id
+ (NSString *)gtAppId
{
    if (EnvirementTag == ProductEnv) {
        return [GTAppId copy];
    }
    else {
        return [GTAppId_dev copy];
    }
}
///个推APP key
+ (NSString *)gtAppKey
{
    if (EnvirementTag == ProductEnv) {
        return [GTAppKey copy];
    }
    else {
        return [GTAppKey_dev copy];
    }
}
///个推APP Secret
+ (NSString *)gtAppSecret
{
    if (EnvirementTag == ProductEnv) {
        return [GTAppSecret copy];
    }
    else {
        return [GTAppSecret_dev copy];
    }
}

@end
