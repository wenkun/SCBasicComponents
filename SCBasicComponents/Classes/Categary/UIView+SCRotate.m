//
//  UIView+SCRotate.m
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/2/13.
//  Copyright © 2018年 静静. All rights reserved.
//

#import "UIView+SCRotate.h"

@implementation UIView (SCRotate)

static BOOL rotateAnimating = NO;

-(void)startRotateAnimation
{
    [self startRotateAnimationWithCycleTime:1.];
}

-(void)startRotateAnimationWithCycleTime:(NSTimeInterval)cycleTime
{
    rotateAnimating = YES;
    [UIView animateWithDuration:cycleTime/2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformRotate(self.transform, M_PI);
    } completion:^(BOOL finished) {
        if (rotateAnimating) {
            [self startRotateAnimationWithCycleTime:cycleTime];
        }
    }];
}

-(void)removeAllAnimations
{
    rotateAnimating = NO;
    [self.layer removeAllAnimations];
}

@end
