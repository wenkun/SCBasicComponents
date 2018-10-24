//
//  SCAreaChoiseView.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/2/27.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import <UIKit/UIKit.h>

///自定义覆盖全屏的PickView弹出View
@interface SCAreaChoiseView : UIView

///PickerView，需设置其代理方法
@property (nonatomic, strong) UIPickerView *pickerView;
///灰色背景
@property (nonatomic, readonly) UIControl *backgroudView;
///弹出框区域
@property (nonatomic, readonly) UIView *contentView;
///pickerView顶部的工具栏
@property (nonatomic, readonly) UIView *topBar;
///topBar的左侧按钮
@property (nonatomic, readonly) UIButton *leftButton;
///topBar的右侧按钮
@property (nonatomic, readonly) UIButton *rightButton;
///topBar上的顶部分割线
@property (nonatomic, readonly) UIView *line;

///取消按钮点击回调
@property (nonatomic, copy) void (^ doCancelButton)(SCAreaChoiseView *areaChoiseView);
///确定按钮点击回调
@property (nonatomic, copy) void (^ doFinishButton)(SCAreaChoiseView *areaChoiseView);
///灰色背景点击回调
@property (nonatomic, copy) void (^ touchBackground)(SCAreaChoiseView *areaChoiseView);

/**
 添加到当前window上。
 */
-(void)showWithAnimation:(BOOL)animation;

/**
 添加到指定的view
 
 @param view super view of SCPickerSuperView
 */
-(void)showInView:(UIView *)view animation:(BOOL)animation;

/**
 隐藏
 */
-(void)dismissWithAnimation:(BOOL)animation;

@end
