//
//  SHAlertController.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/21.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

@class SHAlertController;

/**
 SHAlertController button点击事件回调Block

 @param alertController 当前的SHAlertController
 @param selectIndex 点击的按钮Index
 */
typedef void(^SHAlertControllerSelectedBlock)(SHAlertController * _Nullable alertController, NSInteger selectIndex);

#import <UIKit/UIKit.h>

@interface SHAlertController : NSObject

/**
 初始化SHAlertController

 @param title 标题
 @param message 内容
 @param buttonTitles 按钮Tilte数组
 @param preferredStyle Constants indicating the type of alert to display.
 @return SHAlertController
 */
-(instancetype _Nullable )initWithTitle:(nullable NSString *)title message:(nullable NSString *)message buttonTitles:(nullable NSArray *)buttonTitles preferredStyle:(UIAlertControllerStyle)preferredStyle;

/**
 弹出AlertView

 @param selectedBlock AlertView的button点击事件回调
 */
-(void)showWithSelectedBlcok:(SHAlertControllerSelectedBlock _Nullable )selectedBlock;

/**
 隐藏AlertView
 */
-(void)dismiss;

@end
