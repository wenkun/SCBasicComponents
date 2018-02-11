//
//  UILabel+AutoFrame.m
//  
//
//  Created by 文堃 杜 on 14-9-21.
//  Copyright (c) 2014年 Will. All rights reserved.
//

#import "UILabel+AutoFrame.h"
#import "SCDefaultsUI.h"

@implementation UILabel (AutoFrame)

-(void)setLineDistance:(float)distance
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:distance];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    self.attributedText = attributedString;
}

-(CGSize)setAutoFrameWithText:(NSString *)text lineDistance:(float)distance
{
    CGSize size;
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0)
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:distance];
    NSDictionary *dic = @{NSFontAttributeName: self.font, NSParagraphStyleAttributeName: style};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.frame.size.width, 8000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    size = rect.size;
#else
    size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 8000) lineBreakMode:NSLineBreakByWordWrapping];
#endif
    
    size.height += 2;
    size.height = ceil(size.height);
    
    //修改frame
    CGRect frame = self.frame;
    frame.size.height = size.height;
    frame.size.width = size.width;
    self.frame = frame;
    
    self.text = text;
    if (IsIOS7) {
        [self setLineDistance:distance];
    }
    
    return size;
}

-(CGSize)setAutoFrame
{
    return [self setAutoFrameWithText:self.text];
}

-(CGSize)setAutoFrameWithText:(NSString *)text
{
    CGSize size;
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0)
    NSParagraphStyle *style = [NSParagraphStyle defaultParagraphStyle];
    NSDictionary *dic = @{NSFontAttributeName: self.font, NSParagraphStyleAttributeName: style};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.frame.size.width, 8000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    size = rect.size;
#else
    size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 8000) lineBreakMode:NSLineBreakByWordWrapping];
#endif
    
    size.height += 2;
    size.height = ceil(size.height);
    
    //修改frame
    CGRect frame = self.frame;
    frame.size.height = size.height;
    frame.size.width = size.width;
    self.frame = frame;
    
    self.text = text;
    
    return size;
}

@end
