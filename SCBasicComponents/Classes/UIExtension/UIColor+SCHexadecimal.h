//
//  UIColor+SCHexadecimal.h
//  Pods
//
//  Created by 文堃 杜 on 2018/2/7.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (SCHexadecimal)

/**
 将十六进制颜色值转化为UIColor对象

 @param hexString 十六进制颜色值，000000 或 #000000
 @return UIColor
 */
+(UIColor *)colorWithHexString:(NSString *)hexString;

@end
