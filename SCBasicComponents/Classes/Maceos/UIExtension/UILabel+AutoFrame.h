//
//  UILabel+AutoFrame.h
//
//
//  Created by 文堃 杜 on 14-9-21.
//  Copyright (c) 2014年 Will. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (AutoFrame)

///设置行间距
-(void)setLineDistance:(float)distance;
///根据Label当前text自动适配行数和高度，返回计算后的Size。
-(CGSize)setAutoFrame;
///根据text自动适配行数和高度，返回计算后的Size。
-(CGSize)setAutoFrameWithText:(NSString *)text;
///根据text和行间距自动适配行数和高度，返回计算后的Size。
-(CGSize)setAutoFrameWithText:(NSString *)text lineDistance:(float)distance;

@end
