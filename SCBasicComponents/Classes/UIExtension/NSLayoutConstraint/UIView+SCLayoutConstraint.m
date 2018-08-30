//
//  UIView+SCLayoutConstraint.m
//  SCBasicComponents_Example
//
//  Created by 文堃 杜 on 2018/7/23.
//  Copyright © 2018年 wenkun. All rights reserved.
//

#import "UIView+SCLayoutConstraint.h"
#import "NSLayoutConstraint+SCExtension.h"

@implementation UIView (SCLayoutConstraint)

-(void)updateLayoutConstraint:(NSLayoutConstraint *)layoutConstraint
{
    BOOL update = NO;
    for (NSLayoutConstraint *constraint in self.constraints) {
        if ([layoutConstraint isSamePositionAndRelotionTo:constraint]) {
            [self removeConstraint:constraint];
            update = YES;
        }
    }
    layoutConstraint.active = YES;
    if (update) {
        [self needsUpdateConstraints];
        [self updateFocusIfNeeded];
    }
}

@end
