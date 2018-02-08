//
//  STopAlertView.h
//  GoodAir
//
//  Created by 文堃 杜 on 16/9/21.
//  Copyright © 2016年 青岛海尔科技有限公司. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <YYText/YYText.h>

@class STopAlertView;
typedef void(^STopAlertViewDidClickedButtonBlock)(STopAlertView *topAlertView, UIButton *button);
typedef void(^STopAlertViewDidClickedBackgroundViewBlock)(STopAlertView *topAlertView);

///弹出动画，视图消失的动画为弹出的反向效果。<动画效果可扩充>
typedef enum : NSUInteger {
    ///STopAlertView弹出动画：没有动画
    STopAlertViewAnimationNone,
    ///STopAlertView弹出动画：从顶部下滑动画
    STopAlertViewAnimationFlipFromTop,
} STopAlertViewAnimation;

///STopAlertView的样式
typedef enum : NSUInteger {
    ///第一版设计样式，默认为该样式
    STopAlertViewStyleOriginal,
    ///第二版设计样式，把button样式改为白色空心蓝边框，只能设置一个button
    STopAlertViewStyle1,
} STopAlertViewStyle;


@interface STopAlertView : UIView

///是否已显示
@property (nonatomic, readonly) BOOL isShowing;
///可设置传递对象
@property (nonatomic, assign) id sendObj;

///title text label
@property (nonatomic, readonly) YYLabel *titleLabel;
///content text label
@property (nonatomic, readonly) YYLabel *contentLabel;
///背景View
@property (nonatomic, readonly) UIControl *backGroundView;

///弹出框的最小高度，默认为0
@property (nonatomic, assign) CGFloat minAlertViewHeight;
///设置文本(标题，或者内容)的行间距，默认4.0
@property (nonatomic, assign) CGFloat lineSpace;
///设置一行显示的按钮数量，默认为1
@property (nonatomic, assign) NSInteger buttonNumberInRow;


/**
 *  初始化
 *
 *  @param title       标题，设置为nil或者@""时不显示title
 *  @param contents    内容，数组成员为NSString类型的文本，每个文本会换行显示，设置为nil或者空数组时不显示content
*  @param buttonTitle  button的title，设置为nil或者@""时不显示button
*
*  @return STopAlertView实例
*/
-(instancetype)initWithTitle:(NSString *)title contents:(NSArray *)contents buttonTitle:(NSString *)buttonTitle DEPRECATED_ATTRIBUTE;

/**
 *  初始化
 *
 *  @param title       标题，设置为nil或者@""时不显示title
 *  @param contents    内容，数组成员为NSString类型的文本，每个文本会换行显示，设置为nil或者空数组时不显示content
 *  @param buttonTitlesArray  button的title数组，设置为nil或者@[]时不显示button
 *
 *  @return STopAlertView实例
 */
-(instancetype)initWithTitle:(NSString *)title contents:(NSArray *)contents buttonTitlesArray:(NSArray *)buttonTitlesArray;


/**
 *  初始化
 *
 *  @param title       标题，设置为nil或者@""时不显示title
 *  @param contents    内容，数组成员为NSString类型的文本，每个文本会换行显示，设置为nil或者空数组时不显示content
 *  @param buttonTitlesArray  button的title数组，设置为nil或者@[]时不显示button
 *  @param style 弹出框样式
 *
 *  @return STopAlertView实例
 */
-(instancetype)initWithTitle:(NSString *)title contents:(NSArray *)contents buttonTitlesArray:(NSArray *)buttonTitlesArray style:(STopAlertViewStyle)style;

/**
 带图标的提示框
 */
//-(instancetype)initWithImage:(UIImage*)image Title:(NSString *)title contents:(NSArray *)contents buttonTitle:(NSString *)buttonTitle;
/**
*  弹出STopAlertView，无动画显示
*
*  @param viewController         STopAlertView所要显示在的ViewController
*  @param clickedButtonBlock     点击button
*  @param clickedBackgroundBlock 点击空白处
*/
-(void)showInController:(UIViewController *)viewController clickedButton:(STopAlertViewDidClickedButtonBlock)clickedButtonBlock clickedBackground:(STopAlertViewDidClickedBackgroundViewBlock)clickedBackgroundBlock;

/**
 *  在Window上弹出STopAlertView，无动画显示
 *
 *  @param clickedButtonBlock     点击button
 *  @param clickedBackgroundBlock 点击空白处
 */
-(void)showWithClickedButton:(STopAlertViewDidClickedButtonBlock)clickedButtonBlock clickedBackground:(STopAlertViewDidClickedBackgroundViewBlock)clickedBackgroundBlock;

/**
 *  在Window上弹出STopAlertView，可设置动画
 *
 *  @param animation              弹出动画
 *  @param clickedButtonBlock     点击button
 *  @param clickedBackgroundBlock 点击空白处
 */
-(void)showWithAnimation:(STopAlertViewAnimation)animation clickedButton:(STopAlertViewDidClickedButtonBlock)clickedButtonBlock clickedBackground:(STopAlertViewDidClickedBackgroundViewBlock)clickedBackgroundBlock;

/**
*   移除STopAlertView，无动画效果
*/
-(void)disappear;

/**
 *   移除STopAlertView，带动画效果，相对于弹出动画的反向效果
 *
 *  @param animation              动画，相对于弹出动画的反向效果
 */
-(void)disappearWithAnimatioan:(STopAlertViewAnimation)animation;

/**
 *   移除STopAlertView，带动画效果，相对于弹出动画的反向效果
 *
 *  @param delay                  延迟消失时间
 *  @param animation              动画，相对于弹出动画的反向效果
 */
-(void)disappearAfterDelay:(NSTimeInterval)delay WithAnimatioan:(STopAlertViewAnimation)animation;

///是否有在widow上已显示的Top Alert View
-(BOOL)hasTopAlertViewShowingInWindow;

@end
