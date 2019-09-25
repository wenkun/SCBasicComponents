//
//  NSString+Size.h
//  RenrenEstate
//
//  Created by mouxiaowei on 18/01/03.
//  Copyright © 2018年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UILabel+Contentsize.h"

@interface NSString (Size)

+ (CGFloat)getStringWidth:(NSString *)str maxWidth:(CGFloat)maxWidth label:(UILabel *)label;

+ (NSString *)disableEmoji:(NSString *)text;

+ (CGFloat)getLabelDescHeight:(NSString *)text labelFont:(CGFloat)labelFont maxWidth:(CGFloat)widthF;

@end
