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

/////若已存在相同位置的约束，则更新约束，返回YES；若不存在，则添加此约束，返回NO
//-(BOOL)update;

@end
