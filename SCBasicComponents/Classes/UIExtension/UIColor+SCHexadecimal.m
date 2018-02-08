//
//  UIColor+SCHexadecimal.m
//  Pods
//
//  Created by 文堃 杜 on 2018/2/7.
//
//

#import "UIColor+SCHexadecimal.h"

@implementation UIColor (SCHexadecimal)

+(UIColor *)colorWithHexString:(NSString *)hexString
{
    if (!hexString || hexString.length < 6) {
        return nil;
    }
    
    NSString *hex;
    if ([[hexString substringToIndex:1] isEqualToString:@"#"]) {
        hex = [hexString substringFromIndex:1];
    }
    else {
        hex = hexString;
    }
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setScanLocation:0];
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0 green:((rgbValue & 0xFF00) >> 8) / 255.0 blue:(rgbValue & 0xFF) / 255.0 alpha:1.0];
}

@end
