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
#define IsIOS12 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 12.0? YES : NO)
#define IsIOS13 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 13.0? YES : NO)

//屏幕宽高
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define TopSafeHeight (ScreenHeight >= IsScreen_5_8 ? 44 : 20)
#define BottomSafeHeight (ScreenHeight >= IsScreen_5_8 ? 34 : 0)
#define NavigationHeight (ScreenHeight >= IsScreen_5_8 ? 88 : 64)
#define TabBarHeight (ScreenHeight >= IsScreen_5_8 ? 83 : 49)

//屏幕尺寸
#define IsScreen_3_5 (ScreenHeight == 480)
#define IsScreen_4_0 (ScreenHeight == 568)
#define IsScreen_4_7 (ScreenHeight == 667)
#define IsScreen_5_5 (ScreenHeight == 736)
#define IsScreen_5_8 (ScreenHeight == 812)
#define IsScreen_6_1_6_5 (ScreenHeight == 896) //6.1寸的XR和6.5寸的MAX相同

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

//安全Blcok使用
#define SCSafeBlock(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

#endif

#endif /* SCDefaultsUI_h */
