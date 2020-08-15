//
//  NSLayoutConstraint+SCExtension.h
//  SCBasicComponents_Example
//
//  Created by 文堃 杜 on 2018/7/21.
//  Copyright © 2018年 wenkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (SCExtension)

///是否完全相同的约束
-(BOOL)isEqualTo:(NSLayoutConstraint *)another;
///是否是相同位置的约束，即Item和Attribute相同
-(BOOL)isSamePositionTo:(NSLayoutConstraint *)another;
///是否是相同位置和相同约束关系的约束，即Item、Attribute、relation相同
-(BOOL)isSamePositionAndRelotionTo:(NSLayoutConstraint *)another;

/// 设置fromView的边缘约束等于toView
+ (void)equalConstraintFromView:(UIView *)fromView toView:(UIView *)toView;
/// 基于toView设置fromView的边缘约束
+ (void)equalConstraintFromView:(UIView *)fromView toView:(UIView *)toView sameConstant:(float)constant;
/// 基于toView设置fromView的边缘约束
+ (void)equalConstraintFromView:(UIView *)fromView toView:(UIView *)toView edgeInsets:(UIEdgeInsets)edgeInsets;

@end
