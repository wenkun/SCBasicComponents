//
//  UIView+SCRotate.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/2/13.
//  Copyright © 2018年 静静. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SCRotate)

/**
 开始自动旋转
 */
-(void)startRotateAnimation;

/**
 开始自动旋转

 @param cycleTime 旋转360度所需的时间
 */
-(void)startRotateAnimationWithCycleTime:(NSTimeInterval)cycleTime;

/**
 停止旋转，移除所有动画
 */
-(void)removeAllAnimations;

@end
