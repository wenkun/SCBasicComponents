//
//  SCPickerView.h
//  Robot
//
//  Created by 星星 on 2018/5/19.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCPickerView;
typedef void (^SCPickerViewBlock)(SCPickerView *pickerView);

///自定义覆盖全屏的PickView弹出View
@interface SCPickerView : UIView
///PickerView，需设置其代理方法
@property (nonatomic, strong) UIPickerView *pickerView;

///取消按钮点击回调
@property (nonatomic, copy) SCPickerViewBlock doCancelButtonBlock;
///确定按钮点击回调
@property (nonatomic, copy) SCPickerViewBlock doFinishButtonBlock;
///灰色背景点击回调
@property (nonatomic, copy) SCPickerViewBlock touchBackgroundBlock;

/**
 添加到当前window上。
 */
-(void)show;

/**
 添加到指定的view

 @param view super view of SCPickerView
 */
-(void)showInView:(UIView *)view;

/**
 隐藏
 */
-(void)dismiss;
@end
