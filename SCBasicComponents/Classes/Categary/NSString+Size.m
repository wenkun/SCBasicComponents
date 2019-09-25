//
//  NSString+Size.m
//  RenrenEstate
//
//  Created by mouxiaowei on 18/01/03.
//  Copyright © 2018年 renren. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

+ (CGFloat)getStringWidth:(NSString *)str maxWidth:(CGFloat)maxWidth label:(UILabel *)label {
    CGRect strRect  = [str boundingRectWithSize:CGSizeMake(maxWidth, label.height)
                                        options:NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:label.font}
                                        context:nil];
    CGSize strSize = strRect.size;
    return strSize.width > maxWidth ? maxWidth : strSize.width;
}

+ (CGFloat)getLabelDescHeight:(NSString *)text labelFont:(CGFloat)labelFont maxWidth:(CGFloat)widthF {
    CGSize size = CGSizeZero;
    UILabel * tmp = [[UILabel alloc] init];
    tmp.font = [UIFont systemFontOfSize:labelFont weight:UIFontWeightRegular];
    tmp.width = widthF;
    tmp.text = text;
    tmp.numberOfLines = 0;
    tmp.lineBreakMode = NSLineBreakByWordWrapping;
    size = [tmp contentSize];
    
    return size.height;
}

+ (NSString *)disableEmoji:(NSString *)text {
    
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *modifiedString = [regular stringByReplacingMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length]) withTemplate:@""];
    
    return modifiedString;
    
}

@end
