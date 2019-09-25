//
//  SCMutiPickerView.h
//  Robot
//
//  Created by 文堃 杜 on 2018/8/25.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMutiPickerView : UIView

///tableView，需设置其代理方法
@property (nonatomic, strong) UITableView *tableView;
///设置可见的cell数量，默认为4个。当autoHeightWithCellNumber为YES时，此设置不起作用。
@property (nonatomic, assign) NSInteger visibleCellNumber;
///是否根据Cell的数量自动调整PickerView的高度，默认为YES。高度的显示需要在rangeOfVisibleCellNumber范围内
@property (nonatomic, assign) BOOL autoHeightWithCellNumber;
///可见cell的数量范围。当autoHeightWithCellNumber为YES时，据此范围判断pickerView的高度。默认为 (2,4)，即显示范围为2个到6个之间
@property (nonatomic, assign) NSRange rangeOfVisibleCellNumber;

///取消按钮点击回调
@property (nonatomic, copy) void (^ doCancelButton)(SCMutiPickerView *mutiPickerView);
///确定按钮点击回调
@property (nonatomic, copy) void (^ doFinishButton)(SCMutiPickerView *mutiPickerView);
///灰色背景点击回调
@property (nonatomic, copy) void (^ touchBackground)(SCMutiPickerView *mutiPickerView);

-(void)show;
-(void)showInView:(UIView *)view;
-(void)dismiss;

@end
