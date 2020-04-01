//
//  SCButton.h
//  IntelligentCommunity
//
//  Created by 星星 on 2018/3/1.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 可以对Button内的元素进行自定义的布局，重写布局block，进行自定义布局 例如：
 
 SCButton.titleRectBlock = ^CGRect(CGRect contentRect) {
        return CGRectMake(0, 0, titleSize.width, contentRect.size.height);
    };
 */
@interface SCButton : UIButton
@property (copy, nonatomic) CGRect (^contentRectBlock)(CGRect bounds);
@property (copy, nonatomic) CGRect (^backgroundRectBlock)(CGRect bounds);
@property (copy, nonatomic) CGRect (^imageRectBlock)(CGRect contentRect);
@property (copy, nonatomic) CGRect (^titleRectBlock)(CGRect contentRect);
@end
