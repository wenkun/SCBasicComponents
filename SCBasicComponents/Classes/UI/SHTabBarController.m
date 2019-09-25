//
//  SHTabBarController.m
//  Robot
//
//  Created by 星星 on 2018/5/9.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHTabBarController.h"
#import "SHHomeController.h"
#import "SHViewController.h"
#import "SHNavigationController.h"
#import "SHMineViewController.h"
#import "SHDeviceViewController.h"
#import "SHSceneMainController.h"
#import "SHServeViewController.h"
@interface SHTabBarController () <UITabBarControllerDelegate,UINavigationControllerDelegate>

///场景页面
@property (nonatomic, strong) SHSceneMainController *sceneVC;

@end

@implementation SHTabBarController
#pragma mark - Life Cycle
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addViewcontrollers];
        self.delegate = self;
        self.selectedIndex = 0;
    }
    return self;
}
#pragma mark - Action
/**
 跳转到设备页
 */
- (void)hitDeviceTabbar{
    [self hitTabbarAtIndex:1];
}
/**
 跳转到场景页
 */
- (void)hitSceneTabbar
{
    [self.sceneVC goToPageIndex:1];
    [self hitTabbarAtIndex:2];
}
- (void)hitTabbarAtIndex:(NSInteger)index{
    if (self.viewControllers.count>index&&self.selectedIndex != index) {
        self.selectedIndex = index;
    }
}
- (void)setNormalImage:(UIImage *)normalImage
         selectedImage:(UIImage *)selectedImage
                 title:(NSString *)title
              forNavVC:(UINavigationController *)navVC{
    navVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}
- (void)addViewcontrollers{
    NSArray *titleArray = @[@"家庭",@"设备",@"场景",@"服务",@"我的"];
    NSArray *normalImageArray = @[@"navi_icon_home_rest",
                                  @"navi_icon_device_rest",
                                  @"navi_icon_scene_rest",
                                  @"navi_icon_service_rest",
                                  @"navi_icon_my_rest"];
    NSArray *selectedImageArray = @[@"navi_icon_home_selected",
                                    @"navi_icon_device_selected",
                                    @"navi_icon_scene_selected",
                                    @"navi_icon_service_selected",
                                    @"navi_icon_my_selected"];
    
    SHHomeController *homeController = [[SHHomeController alloc] init];
    SHDeviceViewController *deviceController = [[SHDeviceViewController alloc] init];
    SHSceneMainController *vc3 = [[SHSceneMainController alloc] init];
    [vc3 goToPageIndex:1];
    self.sceneVC = vc3;
    SHServeViewController *vc4 = [[SHServeViewController alloc] init];
    SHMineViewController *vc5 = [[SHMineViewController alloc] init];
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    for (NSInteger i=0; i<titleArray.count; i++) {
        if (i==0) {
            SHNavigationController *navVc = [[SHNavigationController alloc] initWithRootViewController:homeController];
            [self setNormalImage:[UIImage imageNamed:normalImageArray[i]] selectedImage:[UIImage imageNamed:selectedImageArray[i]] title:titleArray[i] forNavVC:navVc];
            [viewControllers addObject:navVc];
            navVc.delegate = self;
        }
        else if (i==1){
            SHNavigationController *navVc = [[SHNavigationController alloc] initWithRootViewController:deviceController];
            [self setNormalImage:[UIImage imageNamed:normalImageArray[i]] selectedImage:[UIImage imageNamed:selectedImageArray[i]] title:titleArray[i] forNavVC:navVc];
            [viewControllers addObject:navVc];
            navVc.delegate = self;
            
        }
        else if (i==2){
            SHNavigationController *navVc = [[SHNavigationController alloc] initWithRootViewController:vc3];
            [self setNormalImage:[UIImage imageNamed:normalImageArray[i]] selectedImage:[UIImage imageNamed:selectedImageArray[i]] title:titleArray[i] forNavVC:navVc];
            [viewControllers addObject:navVc];
            navVc.delegate = self;
            
        }
        else if (i==3){
            SHNavigationController *navVc = [[SHNavigationController alloc] initWithRootViewController:vc4];
            [self setNormalImage:[UIImage imageNamed:normalImageArray[i]] selectedImage:[UIImage imageNamed:selectedImageArray[i]] title:titleArray[i] forNavVC:navVc];
            [viewControllers addObject:navVc];
            navVc.delegate = self;
        }
        else if (i==4){
            SHNavigationController *navVc = [[SHNavigationController alloc] initWithRootViewController:vc5];
            [self setNormalImage:[UIImage imageNamed:normalImageArray[i]] selectedImage:[UIImage imageNamed:selectedImageArray[i]] title:titleArray[i] forNavVC:navVc];
            [viewControllers addObject:navVc];
            navVc.delegate = self;
        }
        
    }
    
    self.viewControllers = viewControllers;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}
#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
}



@end
