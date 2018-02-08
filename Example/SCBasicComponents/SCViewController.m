//
//  SCViewController.m
//  SCBasicComponents
//
//  Created by wenkun on 02/07/2018.
//  Copyright (c) 2018 wenkun. All rights reserved.
//

#import "SCViewController.h"
#import "SCBasicComponents.h"
#import <STopAlertView/STopAlertView.h>

@interface SCViewController ()

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", @(ScreenHeight));
    NSLog(@"%@", @(self.view.frame.size.height));
    
//    UIColor *color = RGBA(110, 110, 110, 1);
    UIColor *color = ColorWithHex(@"000000");
    self.view.backgroundColor = color;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        STopAlertView *alertView = [[STopAlertView alloc] initWithTitle:@"Alert" contents:@[@"[t1]图文测试"] buttonTitlesArray:@[@"cancel",@"OK"]];
        [alertView showWithClickedButton:^(STopAlertView *topAlertView, UIButton *button) {
            [topAlertView disappear];
        } clickedBackground:^(STopAlertView *topAlertView) {
            [topAlertView disappear];
        }];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
