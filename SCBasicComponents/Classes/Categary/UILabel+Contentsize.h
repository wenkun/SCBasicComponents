//
//  UILabel+Contentsize.h
//  Recognizer
//
//  Created by mouxiaowei on 17/12/29.
//  Copyright © 2017年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Contentsize)

- (CGSize)contentSize;

+ (void)setLabelSpace:(UILabel*)label withSpace:(CGFloat)space withFont:(UIFont*)font;

@end
