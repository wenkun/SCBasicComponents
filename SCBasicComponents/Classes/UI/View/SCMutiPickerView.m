//
//  SCMutiPickerView.m
//  Robot
//
//  Created by 文堃 杜 on 2018/8/25.
//  Copyright © 2018年 Haier. All rights reserved.
//


#define TopBarHeight 44

#import "SCMutiPickerView.h"

@interface SCMutiPickerView ()
{
    CGFloat _tableHeight;
    CGFloat _contentHeight;
}

@property (nonatomic, strong) UIControl *backgroudView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, assign) BOOL hadShow;

@end

@implementation SCMutiPickerView

#pragma mark - Lift Style

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
        _tableHeight = 0;
        _contentHeight = 0;
        self.visibleCellNumber = 4;
        self.autoHeightWithCellNumber = YES;
        self.rangeOfVisibleCellNumber = NSMakeRange(2, 4);
        [self addSubviews];
    }
    return self;
}

#pragma mark - View

-(void)addSubviews
{
    [self addSubview:self.backgroudView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.topBar];
    [self.topBar addSubview:self.leftButton];
    [self.topBar addSubview:self.rightButton];
    [self.topBar addSubview:self.line];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutSelfSubviews];
}

-(void)updateConstraints
{
    [super updateConstraints];
}

-(void)layoutSelfSubviews;
{
    NSNumber *topBarHeight = @(TopBarHeight);
    NSNumber *tableHeight = @([self heigthOfTableView]);
    NSNumber *contentHeight = @([self heightOfContentView]);
    NSNumber *screenWidth = @(ScreenWidth);
    NSDictionary *metrics = NSDictionaryOfVariableBindings(topBarHeight, tableHeight, contentHeight, screenWidth);
    NSDictionary *views = NSDictionaryOfVariableBindings(_contentView, _topBar, _tableView, _backgroudView);
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroudView.translatesAutoresizingMaskIntoConstraints = NO;
    self.topBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backgroudView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backgroudView]-0-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentView(contentHeight)]-0-|" options:0 metrics:metrics views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_topBar]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topBar(topBarHeight)]-0-[_tableView(tableHeight)]-0-|" options:0 metrics:metrics views:views]];
    self.tableView.contentSize = CGSizeMake(ScreenWidth, [self heigthOfTableView]);
    
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

///计算要显示的tableView高度
-(CGFloat)heigthOfTableView
{
    if (_tableHeight == 0) {
        NSInteger cellNumbers = 0;
        CGFloat cellHeight = 0;
        //根据cell数量自适应高度情况
        if (self.autoHeightWithCellNumber) {
            if ([self.tableView.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
                cellNumbers = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:0];
            }
            if (cellNumbers < self.rangeOfVisibleCellNumber.location) {
                cellNumbers = self.rangeOfVisibleCellNumber.location;
            }
            else if (cellNumbers > NSMaxRange(self.rangeOfVisibleCellNumber)) {
                cellNumbers = NSMaxRange(self.rangeOfVisibleCellNumber);
            }
        }
        //默认cell数量情况
        else {
            cellHeight = self.visibleCellNumber;
        }
        
        //计算tableview的高度
        if ([self.tableView.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            for (NSInteger i = 0; i < cellNumbers; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                cellHeight += [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:indexPath];
            }
        }
        if (cellHeight <= 0) {
            cellHeight = 44*cellNumbers;
        }
        _tableHeight = ceil(cellHeight)+1+BottomSafeHeight;
    }
    return _tableHeight;
}

-(CGFloat)heightOfContentView
{
    if (_contentHeight == 0) {
        _contentHeight = [self heigthOfTableView]+TopBarHeight;
    }
    return _contentHeight;
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
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, BottomSafeHeight, 0);
        _tableView.alwaysBounceHorizontal = NO;
    }
    return _tableView;
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
    self.frame = view.bounds;
    self.contentView.frame = CGRectMake(0, self.frame.size.height+10, self.frame.size.width, [self heightOfContentView]);
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroudView.alpha = 1;
        self.contentView.frame = CGRectMake(0, self.frame.size.height-[self heightOfContentView], self.frame.size.width, [self heightOfContentView]);
    } completion:^(BOOL finished) {
        self.hadShow = YES;
    }];
}

-(void)dismiss
{
    self.hadShow = NO;
    self.backgroudView.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, [self heightOfContentView]+20, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
