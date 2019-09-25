//
//  SHViewController.h
//  Robot
//
//  Created by 星星 on 2018/5/9.
//  Copyright © 2018年 Haier. All rights reserved.
//

#define LargeTitleContainerHeight 62//ios11以下自定义大标题view的高度

#import <UIKit/UIKit.h>
#import <SCProgressHUD/SCProgressHUD.h>
#import "SHEmptyView.h"
#import "SHCustomLargeTitleView.h"

/**
 定义ViewController的父类，在此实现所有ViewController的共有逻辑
 */
@interface SHViewController : UIViewController

/**  注意：ios11以上使用系统的大标题风格，ios11以下才使用自定义的大标题风格 */
/// 大标题
@property (copy, nonatomic) NSString *largeTitle;
/// container of large title
@property (strong, nonatomic) SHCustomLargeTitleView *largeTitleView NS_DEPRECATED_IOS(9_0,11_0);
///当前View是否展示，从viewWillAppear到viewWillDisappear为YES。
@property (nonatomic, readonly) BOOL isAppearing;

@property (nonatomic, strong) SHEmptyView *currentEmotyView;

/*********************************/
///设置导航栏的返回按钮
-(void)setBackBarButtonItem;
///设置导航栏的返回按钮
-(void)setBackBarButtonItemWithImage:(UIImage *)image;
///返回上级页面
-(void)goBack:(id)sender;
/**
 隐藏导航栏底部默认的线
 */
- (void)hideBottomLineOfNavgationBar;
#pragma mark - HUD

///HUD提示
-(void)showMessageHUD:(NSString *)message;
///展示等待HUD，只在isAppearing为YES时展示
-(void)showLoadingHUD;
///隐藏等到HUD
-(void)hideLoadingHUD;
/**
 显示带有Message的LoadingHUD，只在isAppearing为YES时展示。
 每次调用该方法会创建一个新的SCProgressHUD对象，⚠️同时必须调用SCProgressHUD的hideLoadingMessageHUD方法隐藏该HUD⚠️。
 若Message为nil或者空字符串时，HUD展示UI效果与showLoadingHUD一样。

 @param message 显示在Loading菊花下面的Message。若Message为nil或者空字符串时，HUD展示UI效果与showLoadingHUD一样。
 @return 返回SCProgressHUD对象，通过此对象调用hideLoadingMessageHUD方法。isAppearing为NO时返回nil。
 */
-(SCProgressHUD *)showLoadingHUDWithMessage:(NSString *)message;


#pragma mark - SHEmptyView 无数据页面

/**
 展示网络请求失败的界面（SHEmptyView）
 
 @param superView 父View，一般为self.view
 @param selectedBlock selectedBlock button点击事件回调
 */
-(void)showLoadFailedViewInView:(UIView *)superView
                     buttonSelected:(void(^)(void))selectedBlock;

/**
 展示未开启网络的提示界面

 @param superView 父View，一般为self.view
 @param selectedBlock selectedBlock button点击事件回调
 */
-(void)showNetworkNoneViewInView:(UIView *)superView
                  buttonSelected:(void(^)(void))selectedBlock;

/**
 展示未获取到数据的EmptyView

 @param superView 父View，一般为self.view
 @param imageName 图片名称
 @param title 图片下方标题, 有子标题和无子标题的font不同, 若无设置为nil
 @param subTitle 图片下方子标题, 若无设置为nil
 @param buttonTitle 按钮标题, 若无设置为nil
 @param selectedBlock button点击事件回调
 */
-(void)showEmptyViewInView:(UIView *)superView
             withImageName:(NSString *)imageName
                     title:(NSString *)title
                  subTitle:(NSString *)subTitle
               buttonTitle:(NSString *)buttonTitle
             buttonSelected:(void(^)(void))selectedBlock;

/**
 从父View上移除EmptyView
 */
-(void)removeEmptyView;

/**
 当前展示的EmptyView，只会有一个出现在当前的ViewController上

 @return 当前展示的EmptyView，若无返回nil
 */
-(SHEmptyView *)currentEmotyView;

/**
 从父View上移除NetworkFailureView
 */
-(void)removeNetworkFailureView;
@end
