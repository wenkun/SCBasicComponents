//
//  SHTimePicker.h
//  Robot
//
//  Created by 曹亚男 on 2018/5/16.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import <UIKit/UIKit.h>

///picker样式
typedef NS_ENUM(NSInteger, SHTimePickerType) {
    ///样式：12:59，小时：分钟
    SHTimePickerTypeHourMinute,
    ///样式：59分 59秒
    SHTimePickerTypeMinuteSecond,
};

@interface SHTimePicker : SCAreaChoiseView
///picker样式
@property (nonatomic, assign) SHTimePickerType type;
///补充添加pickerView选中cell的分割线。因弹出方式不同，系统pickerView有时有默认的分割线，有时没有，次值为YES时，则新添加分割线显示。Default is YES。
@property (nonatomic, assign) BOOL complementPickerCellLine;
///选中的数据
@property (nonatomic, readonly) NSArray *selectedTimeCombination;
///选择完成回调（点击确定后）
@property (nonatomic, copy) void (^ didSelectedTime) (SHTimePicker *timePicker, NSArray *timeCombination);
///初始化
-(instancetype)initWithType:(SHTimePickerType)type;
///设置初始选择的数据
-(void)setInitialSelectData:(NSArray *)selectData;

@end
