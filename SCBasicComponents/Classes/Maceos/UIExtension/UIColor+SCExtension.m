//
//  UIColor+SCExtension.m
//  SCBasicComponents_Example
//
//  Created by 星星 on 2018/2/28.
//  Copyright © 2018年 wenkun. All rights reserved.
//

#import "UIColor+SCExtension.h"

@implementation UIColor (SCExtension)
+ (UIColor *)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
