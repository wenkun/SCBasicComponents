//
//  SCAreaChoiseView.m
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/2/27.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SCAreaChoiseView.h"

@interface SCAreaChoiseView ()

@property (nonatomic, strong) UIControl *backgroudView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, assign) BOOL hadShow;

@end

@implementation SCAreaChoiseView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews
{
    [self addSubview:self.backgroudView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.pickerView];
    [self.contentView addSubview:self.topBar];
    [self.topBar addSubview:self.leftButton];
    [self.topBar addSubview:self.rightButton];
    [self.topBar addSubview:self.line];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.constraints.count == 0) {
        [self layoutSelfSubviews];
    }
}

-(void)layoutSelfSubviews;
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_contentView, _topBar, _pickerView, _backgroudView);
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroudView.translatesAutoresizingMaskIntoConstraints = NO;
    self.topBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backgroudView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backgroudView]-0-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentView(245)]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_topBar]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_pickerView]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topBar(44)]-0-[_pickerView(200)]-0-|" options:0 metrics:nil views:views]];
    
    [self layoutTopBarSubviews];
}

-(void)layoutTopBarSubviews
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_leftButton, _rightButton, _line);
    _leftButton.translatesAutoresizingMaskIntoConstraints = NO;
    _rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    [_topBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_leftButton(90)]" options:0 metrics:nil views:views]];
    [_topBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_leftButton]-0-|" options:0 metrics:nil views:views]];
    [_topBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_rightButton(90)]-0-|" options:0 metrics:nil views:views]];
    [_topBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_rightButton]-0-|" options:0 metrics:nil views:views]];
    [_topBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_line]-0-|" options:0 metrics:nil views:views]];
    [_topBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_line(0.5)]" options:0 metrics:nil views:views]];
}

#pragma mark - Property

-(UIControl *)backgroudView
{
    if (!_backgroudView) {
        _backgroudView = [[UIControl alloc] init];
        _backgroudView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_backgroudView addTarget:self action:@selector(touchedBackground:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroudView;
}

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

-(UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

-(UIView *)topBar
{
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor = ColorWithHex(@"f1f1f1");
    }
    return _topBar;
}

-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}

-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(doCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(doFinish:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

#pragma mark - action

-(void)doCancel:(id)sender
{
    if (self.doCancelButton) {
        self.doCancelButton(self);
    }
}

-(void)doFinish:(id)sender
{
    if (self.doFinishButton) {
        self.doFinishButton(self);
    }
}

-(void)touchedBackground:(id)sender
{
    if (!self.hadShow) {
        return;
    }
    if (self.touchBackground) {
        self.touchBackground(self);
    }
}

#pragma mark - Interface

-(void)show
{
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIView* win = [[UIApplication sharedApplication] keyWindow].rootViewController.presentedViewController.view;
    if (!win) {
        win = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
    }
    [self showInView:win];
}

-(void)showInView:(UIView *)view
{
    if (!self.superview) {
        [view addSubview:self];
    }
    [view bringSubviewToFront:self];
    
    self.hadShow = NO;
    self.backgroudView.alpha = 0.001;
    self.contentView.frame = CGRectMake(0, ScreenHeight+10, ScreenWidth, 245);
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroudView.alpha = 1;
        self.contentView.frame = CGRectMake(0, ScreenHeight-245, ScreenWidth, 245);
    } completion:^(BOOL finished) {
        self.hadShow = YES;
    }];
}

-(void)dismiss
{
    self.hadShow = NO;
    self.backgroudView.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, 260, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
