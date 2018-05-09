//
//  SCButton.h
//  IntelligentCommunity
//
//  Created by 星星 on 2018/3/1.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCButton : UIButton
@property (copy, nonatomic) CGRect (^contentRectBlock)(CGRect bounds);
@property (copy, nonatomic) CGRect (^backgroundRectBlock)(CGRect bounds);
@property (copy, nonatomic) CGRect (^imageRectBlock)(CGRect contentRect);
@property (copy, nonatomic) CGRect (^titleRectBlock)(CGRect contentRect);
@end
