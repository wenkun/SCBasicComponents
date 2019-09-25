//
//  SHPickerView.m
//  Robot
//
//  Created by 文堃 杜 on 2018/11/23.
//  Copyright © 2018 Haier. All rights reserved.
//

#import "SHPickerView.h"

@implementation SHPickerView

-(void)setComplementPickerCellLine:(BOOL)complementPickerCellLine
{
    _complementPickerCellLine = complementPickerCellLine;
    [self setPickerViewSelectedCellLines];
}

-(void)setPickerViewSelectedCellLines
{
    if (!self.complementPickerCellLine) {
        UIView *lineTop = [self.pickerView viewWithTag:101];
        if (lineTop) {
            [lineTop removeFromSuperview];
        }
        UIView *lineBottom = [self.pickerView viewWithTag:102];
        if (lineBottom) {
            [lineBottom removeFromSuperview];
        }
        return;
    }
    
    if (![self.pickerView viewWithTag:101]) {
        UIView *lineTop = [[UIView alloc] init];
        lineTop.backgroundColor = ColorLine;
        lineTop.tag = 101;
        [self.pickerView addSubview:lineTop];
        
        lineTop.translatesAutoresizingMaskIntoConstraints = NO;
        [lineTop.leftAnchor constraintEqualToAnchor:self.pickerView.leftAnchor].active = YES;
        [lineTop.rightAnchor constraintEqualToAnchor:self.pickerView.rightAnchor].active = YES;
        [lineTop.centerYAnchor constraintEqualToAnchor:self.pickerView.centerYAnchor constant:-23].active = YES;
        [lineTop.heightAnchor constraintEqualToConstant:1].active = YES;
    }
    
    if (![self.pickerView viewWithTag:102]) {
        UIView *lineBottom = [[UIView alloc] init];
        lineBottom.backgroundColor = ColorLine;
        lineBottom.tag = 102;
        [self.pickerView addSubview:lineBottom];
        
        lineBottom.translatesAutoresizingMaskIntoConstraints = NO;
        [lineBottom.leftAnchor constraintEqualToAnchor:self.pickerView.leftAnchor].active = YES;
        [lineBottom.rightAnchor constraintEqualToAnchor:self.pickerView.rightAnchor].active = YES;
        [lineBottom.centerYAnchor constraintEqualToAnchor:self.pickerView.centerYAnchor constant:22].active = YES;
        [lineBottom.heightAnchor constraintEqualToConstant:1].active = YES;
    }
}

@end
