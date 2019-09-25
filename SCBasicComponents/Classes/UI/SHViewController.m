//
//  SHViewController.m
//  Robot
//
//  Created by 星星 on 2018/5/9.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHViewController.h"
#import "SCDefaultsUI.h"
#import "NSString+SCExtension.h"
#import "UIImage+SCExtension.h"
#import "SHUmengLogManager.h"

@interface SHViewController ()
{
    UIColor *_tmpStatusbarColor;
}
///
@property (strong, nonatomic) NSMutableArray<__kindof NSLayoutConstraint *> *largeTitleChangeConstraints;


@end

@implementation SHViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (!IsIOS11&&self.largeTitleView.superview&&self.view.subviews.count>1) {
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if (constraint.constant == 0&&
                constraint.firstAttribute==NSLayoutAttributeTop&&
                constraint.secondAttribute==NSLayoutAttributeTop&&
                ![constraint.firstItem isKindOfClass:[SHCustomLargeTitleView class]]) {
                id firstItem = constraint.firstItem;
                id secondItem = constraint.secondItem;
                if ([firstItem isKindOfClass:[UIView class]] &&
                    [secondItem isKindOfClass:[UIView class]] &&
                    ((UIView *)secondItem).superview == firstItem) {
                    constraint.constant = -LargeTitleContainerHeight;
                }else{
                    constraint.constant = LargeTitleContainerHeight;
                }
                [_largeTitleChangeConstraints addObject:constraint];
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[SHUmengLogManager sharedUMLogManager] beginLogPageView:NSStringFromClass(self.class)];
    _isAppearing = YES;
    
    if ([self.largeTitle isNotBlank]) {
        if (@available(iOS 11.0, *)) {
            self.navigationController.navigationBar.prefersLargeTitles = YES;
        }
    }
    else {
        if (@available(iOS 11.0, *)) {
            self.navigationController.navigationBar.prefersLargeTitles = NO;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[SHUmengLogManager sharedUMLogManager] endLogPageView:NSStringFromClass(self.class)];
    _isAppearing = NO;
}

#pragma mark - ios11以下 大标题栏
- (void)setShowLargeTitleView:(BOOL)showLargeTitleView{
    if (IsIOS11) return;
    if (showLargeTitleView) {
        if (!self.largeTitleView.superview) {
            [self.view addSubview:self.largeTitleView];
        }

        NSMutableArray *oldConstraints = [NSMutableArray array];
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if ([constraint.firstItem isKindOfClass:[SHCustomLargeTitleView class]] ||
                [constraint.secondItem isKindOfClass:[SHCustomLargeTitleView class]]) {
                [oldConstraints addObject:constraint];
            }
        }
        [self.view removeConstraints:oldConstraints];
        NSNumber *largeTitleContainerH = [NSNumber numberWithInteger:LargeTitleContainerHeight];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_largeTitleView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_largeTitleView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_largeTitleView(largeTitleContainerH)]" options:0 metrics:NSDictionaryOfVariableBindings(largeTitleContainerH) views:NSDictionaryOfVariableBindings(_largeTitleView)]];
    }
    else{
        [self.largeTitleView removeFromSuperview];
        for (NSLayoutConstraint *constraint in _largeTitleChangeConstraints) {
            constraint.constant = 0;
        }
    }
    [_largeTitleChangeConstraints removeAllObjects];
}
- (void)setLargeTitle:(NSString *)largeTitle
{
    [self hideBottomLineOfNavgationBar];//隐藏导航栏底部的线.
    _largeTitle  = largeTitle;
    if (IsIOS11) {
        self.navigationItem.title = largeTitle;
    }
    else {
        self.largeTitleView.titleLabel.text = _largeTitle;
        [self setShowLargeTitleView:(_largeTitle != nil)];
    }
}

-(SHCustomLargeTitleView *)largeTitleView
{
    if (!_largeTitleView) {
        //ios11以下 大标题栏风格
        if (!IsIOS11) {
            _largeTitleView = [SHCustomLargeTitleView LargeTitleView];
            _largeTitleView.translatesAutoresizingMaskIntoConstraints = NO;
            _largeTitleChangeConstraints = [NSMutableArray array];
        }
    }
    return _largeTitleView;
}

#pragma mark - navigationItem
/**
 隐藏导航栏底部默认的线
 */
- (void)hideBottomLineOfNavgationBar{
    if (IsIOS11) {
        UIImageView *bottomLine = [self foundNavigationBarBottomLine:self.navigationController.navigationBar];
        if (bottomLine) {
            bottomLine.hidden = YES;
        }
        if (self.navigationController.navigationBar.subviews.count > 0) {
            UIImageView *navLine = [self.navigationController.navigationBar.subviews[0] viewWithTag:5757];
            if (navLine) {
                navLine.hidden = YES;
            }
        }
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//        self.view.backgroundColor = [UIColor whiteColor];
    }else{
        if (self.navigationController) {
            UINavigationBar *navigationBar = self.navigationController.navigationBar;
            [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
            navigationBar.shadowImage = [[UIImage alloc] init];
            navigationBar.backgroundColor = [UIColor whiteColor];
        }
    }
}

//寻找底部横线
- (UIImageView *)foundNavigationBarBottomLine:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self foundNavigationBarBottomLine:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

-(void)setBackBarButtonItem
{
    [self setBackBarButtonItemWithImage:nil];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_navigation_bar_return"] style:UIBarButtonItemStyleDone target:self action:@selector(goBack:)];
}
-(void)setBackBarButtonItemWithImage:(UIImage *)image{
    if (!image) {
        image = [UIImage imageNamed:@"btn_navigation_bar_return"];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(goBack:)];
}
/** Action **/
-(void)goBack:(id)sender
{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - HUD

-(void)showMessageHUD:(NSString *)message
{
    [SCProgressHUD showMessage:message toView:self.view];
}

///展示等待HUD
-(void)showLoadingHUD
{
    if (self.isAppearing) {
        [SCProgressHUD showLoadingHUD];
    }
}
///隐藏等到HUD
-(void)hideLoadingHUD
{
    [SCProgressHUD hideLoadingHUD];
}

/**
 显示带有Message的LoadingHUD。
 ⚠️每次调用该方法会创建一个新的SCProgressHUD对象，同时必须调用SCProgressHUD的hideLoadingMessageHUD方法隐藏该HUD⚠️。
 若Message为nil或者空字符串时，HUD展示UI效果与showLoadingHUD一样。
 
 @param message 显示在Loading菊花下面的Message。若Message为nil或者空字符串时，HUD展示UI效果与showLoadingHUD一样。
 @return 返回SCProgressHUD对象，通过此对象调用hideLoadingMessageHUD方法。
 */
-(SCProgressHUD *)showLoadingHUDWithMessage:(NSString *)message
{
    if (self.isAppearing) {
        return [SCProgressHUD showLoadingHUDWithMessage:message];
    }
    return nil;
}

#pragma mark - 无数据页面展示

-(void)showEmptyViewInView:(UIView *)superView withImageName:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle buttonTitle:(NSString *)buttonTitle buttonSelected:(void (^)(void))selectedBlock
{
    [self removeEmptyView];
    SHEmptyView *view = [[SHEmptyView alloc] initWithImageName:imageName title:title subTitle:subTitle buttonTitle:buttonTitle];
    [view addToView:superView withButtonSelected:selectedBlock];
    self.currentEmotyView = view;
}

-(void)removeEmptyView
{
    if (self.currentEmotyView) {
        [self.currentEmotyView removeFromSuperview];
        self.currentEmotyView = nil;
    }
}

-(void)showLoadFailedViewInView:(UIView *)superView
                     buttonSelected:(void(^)(void))selectedBlock
{
    [self showEmptyViewInView:superView withImageName:@"jiazaishibai" title:@"加载失败" subTitle:@"再试一下" buttonTitle:@"重新加载" buttonSelected:selectedBlock];
    [self.currentEmotyView setBackgroundStyle:SHEmptyViewBackgroundStyleGray];
    [self.currentEmotyView setButtonStyle:SHEmptyViewButtonStyleGray];
}

-(void)showNetworkNoneViewInView:(UIView *)superView
                 buttonSelected:(void(^)(void))selectedBlock
{
    [self showEmptyViewInView:superView withImageName:@"img_jiazaishibai" title:@"网络未开启" subTitle:@"请检查网络设置" buttonTitle:@"重新加载" buttonSelected:selectedBlock];
    [self.currentEmotyView setBackgroundStyle:SHEmptyViewBackgroundStyleGray];
    [self.currentEmotyView setButtonStyle:SHEmptyViewButtonStyleGray];
}

-(void)removeNetworkFailureView{
    [self removeEmptyView];
}
@end
