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

@end
