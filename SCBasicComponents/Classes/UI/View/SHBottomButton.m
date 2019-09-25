//
//  SHBottomButton.m
//  Robot
//
//  Created by 文堃 杜 on 2018/6/15.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHBottomButton.h"

@implementation SHBottomButton

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBackgroundImage:[UIImage imageWithColor:ColorMain] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[ColorMain colorWithAlphaComponent:0.4]] forState:UIControlStateDisabled];
    [self changeButtonTitle:self.titleLabel.text];
}

-(void)changeButtonTitle:(NSString *)title
{
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:16]}];
    [self setAttributedTitle:attString forState:UIControlStateNormal];
}

@end
