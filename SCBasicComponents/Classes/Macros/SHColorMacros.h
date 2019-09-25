//
//  SHColorMacros.h
//  Robot
//
//  Created by 文堃 杜 on 2018/6/4.
//  Copyright © 2018年 Haier. All rights reserved.
//

#ifndef SHColorMacros_h
#define SHColorMacros_h

#import <SCBasicComponents/SCDefaultsUI.h>

/** APP通用色调 **/
//主色
#define ColorMain ColorWithHex(@"5f84ee")
//通用页面背景色
#define ColorBackground ColorWithHex(@"f5f5f5")
//分割线颜色
#define ColorLine ColorWithHex(@"e4e4e4")

//默认的文字颜色
#define ColorTextDefault ColorWithHex(@"333333")

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* SHColorMacros_h */
