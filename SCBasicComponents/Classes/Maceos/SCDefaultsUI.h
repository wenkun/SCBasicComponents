//
//  SCDefaultsUI.h
//  Pods
//
//  Created by 文堃 杜 on 2018/2/7.
//
//

#ifndef SCDefaultsUI_h
#define SCDefaultsUI_h

#ifdef __OBJC__
#import "UIColor+SCHexadecimal.h"

//system
#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0? YES : NO)
#define IsIOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0? YES : NO)
#define IsIOS9 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0? YES : NO)
#define IsIOS10 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0? YES : NO)
#define IsIOS11 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 11.0? YES : NO)

//屏幕宽高
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define TopSafeHeight (IsScreen_5_8 ? 44 : 20)
#define BottomSafeHeight (IsScreen_5_8 ? 34 : 0)
#define NavigationHeight (IsScreen_5_8 ? 88 : 64)
#define TabBarHeight (IsScreen_5_8 ? 83 : 49)

//屏幕尺寸
#define IsScreen_3_5 (ScreenHeight == 480)
#define IsScreen_4_0 (ScreenHeight == 568)
#define IsScreen_4_7 (ScreenHeight == 667)
#define IsScreen_5_5 (ScreenHeight == 736)
#define IsScreen_5_8 (ScreenHeight == 812)


//颜色和透明度设置
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
//十六进制颜色
#define ColorWithHex(hexString) [UIColor colorWithHexString:hexString]

//字符串 数字类型转换
#define IntegerToString(a) [[NSNumber numberWithInteger:a] stringValue]
#define IntegerToFloat(a)  [[NSNumber numberWithInteger:a] floatValue]
#define FloatToString(a)   [[NSNumber numberWithFloat:a] stringValue]
#define DoubleToString(a)  [[NSNumber numberWithDouble:a] stringValue]
#define StringToDouble(a)  [[NSNumber numberWithString:a] doubleValue]
#define StringToFloat(a)   [[NSNumber numberWithString:a] floatValue]
#define StringToInteger(a) [[NSNumber numberWithString:a] integerValue]

#endif

#endif /* SCDefaultsUI_h */
