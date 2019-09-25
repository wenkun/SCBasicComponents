//
//  SHPickerView.h
//  Robot
//
//  Created by 文堃 杜 on 2018/11/23.
//  Copyright © 2018 Haier. All rights reserved.
//

#import "SCAreaChoiseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHPickerView : SCAreaChoiseView

///补充添加pickerView选中cell的分割线。因弹出方式不同，系统pickerView有时有默认的分割线，有时没有，次值为YES时，则新添加分割线显示。Default is YES。
@property (nonatomic, assign) BOOL complementPickerCellLine;

@end

NS_ASSUME_NONNULL_END
