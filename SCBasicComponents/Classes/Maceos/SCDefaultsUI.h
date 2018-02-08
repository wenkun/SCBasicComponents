//
//  SCDefaultsUI.h
//  Pods
//
//  Created by 文堃 杜 on 2018/2/7.
//
//

#ifndef SCDefaultsUI_h
#define SCDefaultsUI_h

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

//屏幕尺寸
#define IsScreen_3_5 (ScreenHeight == 480)
#define IsScreen_4_0 (ScreenHeight == 568)
#define IsScreen_4_7 (ScreenHeight == 667)
#define IsScreen_5_5 (ScreenHeight == 736)
#define IsScreen_5_8 (ScreenHeight == 812)


//从storyboard里获取ViewController
#define ViewControllerFromStoryboard(storyboardName, viewControllerId) [[UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:viewControllerId]


//颜色和透明度设置
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
//十六进制颜色
#define ColorWithHex(hexString) [UIColor colorWithHexString:hexString]

#endif /* SCDefaultsUI_h */
