//
//  SCPickerSuperView.h
//  Robot
//
//  Created by 星星 on 2018/5/19.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCPickerSuperView;
typedef void (^SCPickerSuperViewBlock)(SCPickerSuperView *pickerSuperView);

///自定义覆盖全屏的PickView弹出View
@interface SCPickerSuperView : UIView
///PickerView，需设置其代理方法
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, readonly) UIControl *backgroudView;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) UIView *topBar;
@property (nonatomic, readonly) UIButton *leftButton;
@property (nonatomic, readonly) UIButton *rightButton;
@property (nonatomic, readonly) UIView *line;

///取消按钮点击回调
@property (nonatomic, copy) SCPickerSuperViewBlock doCancelButtonBlock;
///确定按钮点击回调
@property (nonatomic, copy) SCPickerSuperViewBlock doFinishButtonBlock;
///灰色背景点击回调
@property (nonatomic, copy) SCPickerSuperViewBlock touchBackgroundBlock;

/**
 添加到当前window上。
 */
-(void)show;

/**
 添加到指定的view

 @param view super view of SCPickerSuperView
 */
-(void)showInView:(UIView *)view;

/**
 隐藏
 */
-(void)dismiss;
@end
