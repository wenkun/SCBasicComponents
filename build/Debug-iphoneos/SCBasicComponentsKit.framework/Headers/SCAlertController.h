//
//  SCAlertController.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/21.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

@class SCAlertController;

/**
 SCAlertController button点击事件回调Block

 @param alertController 当前的SCAlertController
 @param selectIndex 点击的按钮Index
 */
typedef void(^SCAlertControllerSelectedBlock)(SCAlertController * _Nullable alertController, NSInteger selectIndex);

#import <UIKit/UIKit.h>

/**
 对UIAlertController封装
 */
@interface SCAlertController : NSObject

/**
 封装的UIAlertController
 */
@property (nonatomic, readonly) UIAlertController * _Nullable alertController;

/**
 初始化SCAlertController

 @param title 标题
 @param message 内容
 @param buttonTitles 按钮Tilte数组
 @param preferredStyle Constants indicating the type of alert to display.
 @return SCAlertController
 */
-(instancetype _Nullable )initWithTitle:(nullable NSString *)title message:(nullable NSString *)message buttonTitles:(nullable NSArray *)buttonTitles preferredStyle:(UIAlertControllerStyle)preferredStyle;

/**
 弹出AlertView

 @param selectedBlock AlertView的button点击事件回调
 */
-(void)showWithSelectedBlcok:(SCAlertControllerSelectedBlock _Nullable )selectedBlock;

/**
 隐藏AlertView
 */
-(void)dismiss;

@end
