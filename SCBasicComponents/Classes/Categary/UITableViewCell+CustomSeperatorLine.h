//
//  UITableViewCell+CustomSeperatorLine.h
//  GoodAir
//
//  Created by 尹啟星 on 2017/8/23.
//  Copyright © 2017年 尹啟星. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat leftMargin;
    CGFloat rightMargin;
} HorizontalMargins;

extern const HorizontalMargins HorizontalMarginsNull;

extern bool HorizontalMarginsIsNull(HorizontalMargins margins);


/**
 为cell 底部添加分割线
 */
@interface UITableViewCell (CustomSeperatorLine)
- (void)removeBottomLine;
/**
 高度 0.8的默认 leftMargin 15 color f2f2f2
 */
- (void)setDefaultBottomSeperatorLine;

/**
 高度 0.8的默认 leftMargin 15

 @param color  线的颜色
 */
- (void)setDefaultBottomSeperatorLineWithColor:(UIColor *)color;

/**
 高度 0.8的默认 color f2f2f2

 @param left 左边距离
 @param right 右边距离
 */
- (void)setDefaultBottomSeperatorLineWithLeft:(CGFloat)left
                                        right:(CGFloat)right;

/**
 高度默认0.8

 @param left 左边距离
 @param right 右边距离
 @param color 线的颜色
 */
- (void)setBottomSeperatorLineWithLeft:(CGFloat)left
                                 right:(CGFloat)right
                                 color:(UIColor *)color;

/**
 初始化cell底部分割线

 @param left 左边距离
 @param right 右边距离
 @param color 线的颜色
 @param lineHeight 高度
 */
- (void)setBottomSeperatorLineWithLeft:(CGFloat)left
                                 right:(CGFloat)right
                                 color:(UIColor *)color
                            lineHeight:(CGFloat)lineHeight;
- (void)setBottomSeperatorLineWithMargins:(HorizontalMargins)margins
                                       color:(UIColor *)color
                                   lineHeight:(CGFloat)lineHeight;

- (void)setTopSeperatorLineWithMargins:(HorizontalMargins)margins
                                    color:(UIColor *)color
                                lineHeight:(CGFloat)lineHeight;

@end
