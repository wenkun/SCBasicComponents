//
//  SHNavigationController.m
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/23.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SHNavigationController.h"

@interface SHNavigationController ()

@end

@implementation SHNavigationController

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    //2.设置导航栏左右侧按钮和图片颜色
    [bar setTintColor:ColorWithHex(@"333333")];
    //3.设置导航栏标题图片
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName : ColorWithHex(@"333333")};
    [bar setTitleTextAttributes:textAttributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**拦截所有的要push的控制器**/
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        //进入二级页面自动显示和隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
