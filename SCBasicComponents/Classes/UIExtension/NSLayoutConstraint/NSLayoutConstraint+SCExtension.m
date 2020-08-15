//
//  NSLayoutConstraint+SCExtension.m
//  SCBasicComponents_Example
//
//  Created by 文堃 杜 on 2018/7/21.
//  Copyright © 2018年 wenkun. All rights reserved.
//

#import "NSLayoutConstraint+SCExtension.h"

@implementation NSLayoutConstraint (SCExtension)

- (BOOL)isEqualTo:(NSLayoutConstraint *)another
{
    if (self.firstItem == another.firstItem &&
        self.firstAttribute == another.firstAttribute &&
        self.secondItem == another.secondItem &&
        self.secondAttribute == another.secondAttribute &&
        self.relation == another.relation &&
        self.multiplier == another.multiplier &&
        self.constant == another.constant) {
        return YES;
    }
    return NO;
}

-(BOOL)isSamePositionTo:(NSLayoutConstraint *)another
{
    
    if (self.firstItem == another.firstItem &&
        self.firstAttribute == another.firstAttribute &&
        self.secondItem == another.secondItem &&
        self.secondAttribute == another.secondAttribute) {
        return YES;
    }
    return NO;
}

-(BOOL)isSamePositionAndRelotionTo:(NSLayoutConstraint *)another
{
    if ([self isSamePositionTo:another] &&
        self.relation == another.relation) {
        return YES;
    }
    return NO;
}


+ (void)equalConstraintFromView:(UIView *)fromView toView:(UIView *)toView
{
    [NSLayoutConstraint equalConstraintFromView:fromView toView:toView sameConstant:0];
}

+ (void)equalConstraintFromView:(UIView *)fromView toView:(UIView *)toView sameConstant:(float)constant
{
    [NSLayoutConstraint equalConstraintFromView:fromView toView:toView edgeInsets:UIEdgeInsetsMake(constant, constant, constant, constant)];
}

+ (void)equalConstraintFromView:(UIView *)fromView toView:(UIView *)toView edgeInsets:(UIEdgeInsets)edgeInsets
{
    fromView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [fromView.leftAnchor constraintEqualToAnchor:toView.leftAnchor constant:edgeInsets.left],
        [fromView.topAnchor constraintEqualToAnchor:toView.topAnchor constant:edgeInsets.top],
        [fromView.rightAnchor constraintEqualToAnchor:toView.rightAnchor constant:-edgeInsets.right],
        [fromView.bottomAnchor constraintEqualToAnchor:toView.bottomAnchor constant:-edgeInsets.bottom],
       ]];
}

@end
