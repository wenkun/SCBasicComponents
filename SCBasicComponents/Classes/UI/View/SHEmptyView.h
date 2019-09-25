//
//  SHEmptyView.h
//  Robot
//
//  Created by 文堃 杜 on 2018/6/2.
//  Copyright © 2018年 Haier. All rights reserved.
//



#import <Foundation/Foundation.h>
///button样式
typedef enum : NSUInteger {
    ///灰色样式，用于加载失败等
    SHEmptyViewButtonStyleGray,
    ///蓝色样式，APP主色调的button样式（默认）
    SHEmptyViewButtonStyleBlue,
} SHEmptyViewButtonStyle;

///背景颜色风格
typedef enum : NSUInteger {
    ///灰色背景
    SHEmptyViewBackgroundStyleGray,
    ///白色背景（默认）
    SHEmptyViewBackgroundStyleWhite,
} SHEmptyViewBackgroundStyle;

#import <UIKit/UIKit.h>

@interface SHEmptyView : UIView

/**
 手势事件是否可透传给superView，默认为NO。
 */
@property (nonatomic, assign) BOOL touchCanTranfser;

/**
 初始化

 @param imageName 图片名称
 @param title 图片下方标题, 有子标题和无子标题的font不同, 若无设置为nil
 @param subTitle 图片下方子标题, 若无设置为nil
 @param buttonTitle 按钮标题, 若无设置为nil
 @return SHEmptyView
 */
-(instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle buttonTitle:(NSString *)buttonTitle;

/**
 添加到父类View，并设置好约束

 @param superView 父类View
 @param selectedBlock 点击button事件回调
 */
-(void)addToView:(UIView *)superView withButtonSelected:(void(^)(void))selectedBlock;

/**
 设置button的样式风格

 @param style button的样式选择
 */
-(void)setButtonStyle:(SHEmptyViewButtonStyle)style;

/**
 设置背景风格

 @param style 背景风格
 */
-(void)setBackgroundStyle:(SHEmptyViewBackgroundStyle)style;

#pragma mark - private

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIButton *button;

@end
