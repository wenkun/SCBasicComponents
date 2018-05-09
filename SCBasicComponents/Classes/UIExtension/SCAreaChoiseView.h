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
///取消按钮点击回调
@property (nonatomic, copy) void (^ doCancelButton)(SCAreaChoiseView *areaChoiseView);
///确定按钮点击回调
@property (nonatomic, copy) void (^ doFinishButton)(SCAreaChoiseView *areaChoiseView);
///灰色背景点击回调
@property (nonatomic, copy) void (^ touchBackground)(SCAreaChoiseView *areaChoiseView);

-(void)show;
-(void)showInView:(UIView *)view;
-(void)dismiss;

@end
