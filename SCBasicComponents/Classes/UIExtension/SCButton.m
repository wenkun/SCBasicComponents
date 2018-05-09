//
//  SCButton.m
//  IntelligentCommunity
//
//  Created by 星星 on 2018/3/1.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SCButton.h"

@implementation SCButton
- (CGRect)backgroundRectForBounds:(CGRect)bounds{
    CGRect rect = CGRectZero;
    if (_backgroundRectBlock) {
        rect = _backgroundRectBlock(bounds);
    }
    else{
        rect = [super backgroundRectForBounds:bounds];
        
    }
    return rect;
}
- (CGRect)contentRectForBounds:(CGRect)bounds{
    if (_contentRectBlock) {
        return _contentRectBlock(bounds);
    }
    return [super contentRectForBounds:bounds];
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rect = CGRectZero;
    if (_titleRectBlock) {
        rect = _titleRectBlock(contentRect);
    }
    else{
        rect = [super titleRectForContentRect:contentRect];
    }
    return rect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rect = CGRectZero;
    if (_imageRectBlock) {
        rect = _imageRectBlock(contentRect);
    }
    else{
        rect = [super imageRectForContentRect:contentRect];
    }
    
    return rect;
}
@end
