//
//  SHEmptyView.m
//  Robot
//
//  Created by 文堃 杜 on 2018/6/2.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHEmptyView.h"
#import "SCDefaultsUI.h"
#import "SHColorMacros.h"
#import "SHBasicHeader.h"
#import "UIImage+SCExtension.h"

@interface SHEmptyView ()

@property (nonatomic, copy) void (^ didSelectedButtonBlock)(void);

@end

@implementation SHEmptyView

#pragma mark - interface

-(instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle buttonTitle:(NSString *)buttonTitle
{
    if (self = [super init]) {
        [self setBackgroundStyle:SHEmptyViewBackgroundStyleWhite];
        
        //imageView的中心点距离superView中心向上的偏移量
        CGFloat centerDistance = 30 + (title ? 15 : 0) + (subTitle ? 15 : 0) + (buttonTitle ? 45 : 0);
        
        //imageview
        self.imageView.image = [UIImage imageNamed:imageName];
        [self addSubview:self.imageView];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
        [self.imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-centerDistance].active = YES;
        
        UIView *lastView = self.imageView;
        
        //label
        if (title) {
            self.label.text = title;
            //有副标题时label样式有所不同
            if (subTitle) {
                self.label.font = [UIFont boldSystemFontOfSize:16];
                self.label.textColor = ColorWithHex(@"6d717c");
            }
            else {
                self.label.font = [UIFont systemFontOfSize:14];
                self.label.textColor = ColorWithHex(@"a4a7b5");
            }
            [self addSubview:self.label];
            self.label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.label.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:12].active = YES;
            [self.label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
            [self.label.leftAnchor constraintGreaterThanOrEqualToAnchor:self.leftAnchor constant:20].active = YES;
            [self.label.rightAnchor constraintLessThanOrEqualToAnchor:self.rightAnchor constant:20].active = YES;
            
            lastView = self.label;
        }
        
        //subLable & label
        if (subTitle) {
            self.subLabel.text = subTitle;
            self.subLabel.font = [UIFont systemFontOfSize:12];
            self.subLabel.textColor = ColorWithHex(@"adafb3");
            [self addSubview:self.subLabel];
            self.subLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [self.subLabel.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:10].active = YES;
            [self.subLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
            [self.subLabel.leftAnchor constraintGreaterThanOrEqualToAnchor:self.leftAnchor constant:20].active = YES;
            [self.subLabel.rightAnchor constraintLessThanOrEqualToAnchor:self.rightAnchor constant:20].active = YES;
            
            lastView = self.subLabel;
        }
        
        //button
        if (buttonTitle) {
            [self.button setTitle:buttonTitle forState:UIControlStateNormal];
            [self setButtonStyle:SHEmptyViewButtonStyleBlue];
            [self.button addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.button];
            self.button.translatesAutoresizingMaskIntoConstraints = NO;
            [self.button.topAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:30].active = YES;
            [self.button.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
            [self.button.heightAnchor constraintEqualToConstant:46].active = YES;
            [self.button.widthAnchor constraintEqualToConstant:236].active = YES;
        }
    }
    return self;
}

-(void)addToView:(UIView *)superView withButtonSelected:(void (^)(void))selectedBlock
{
    if (!superView || ![superView isKindOfClass:[UIView class]]) {
        return;
    }
    
    self.frame = superView.bounds;
    self.didSelectedButtonBlock = selectedBlock;
    [superView addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topAnchor constraintEqualToAnchor:superView.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:superView.bottomAnchor].active = YES;
    [self.leftAnchor constraintEqualToAnchor:superView.leftAnchor].active = YES;
    [self.rightAnchor constraintEqualToAnchor:superView.rightAnchor].active = YES;
}

-(void)setButtonStyle:(SHEmptyViewButtonStyle)style
{
    switch (style) {
        case SHEmptyViewButtonStyleGray:
            {
                self.button.layer.cornerRadius = 5;
                self.button.layer.borderColor = ColorWithHex(@"e4e4e4").CGColor;
                self.button.layer.borderWidth = 1;
                self.button.clipsToBounds = YES;
                [self.button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.button.titleLabel.text attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : ColorWithHex(@"6d717c")}];
                [self.button setAttributedTitle:attString forState:UIControlStateNormal];
            }
            break;
            
        case SHEmptyViewButtonStyleBlue:
        {
            self.button.layer.cornerRadius = 23;
            self.button.layer.borderWidth = 0;
            self.button.clipsToBounds = YES;
            [self.button setBackgroundImage:[UIImage imageWithColor:ColorMain] forState:UIControlStateNormal];
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.button.titleLabel.text attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName : [UIColor whiteColor]}];
            [self.button setAttributedTitle:attString forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

-(void)setBackgroundStyle:(SHEmptyViewBackgroundStyle)style
{
    switch (style) {
        case SHEmptyViewBackgroundStyleGray:
            {
                self.backgroundColor = ColorBackground;
            }
            break;
            
        case SHEmptyViewBackgroundStyleWhite:
        {
            self.backgroundColor = [UIColor whiteColor];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - action

-(void)selectedButton:(id)sender
{
    SHSafeBlock(self.didSelectedButtonBlock);
}

#pragma mark - property

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

-(UILabel *)subLabel
{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
    }
    return _subLabel;
}

-(UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _button;
}

#pragma mark - touch

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return !self.touchCanTranfser;
}

@end
