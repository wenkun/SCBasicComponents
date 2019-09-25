//
//  SCAlertController.m
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/21.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SCAlertController.h"

@interface SCAlertController ()

@property (nonatomic, copy) SCAlertControllerSelectedBlock selectedBlock;
@property (nonatomic, strong) NSArray *buttonTitles;

@end

@implementation SCAlertController

-(instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message buttonTitles:(nullable NSArray *)buttonTitles preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    if (self = [super init]) {
        _alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
        self.buttonTitles = buttonTitles;
        for (NSString *name in buttonTitles) {
            [_alertController addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [self selectedAction:action];
            }]];
        }
    }
    return self;
}

-(void)selectedAction:(UIAlertAction *)action
{
    for (NSInteger i = 0; i < self.buttonTitles.count; i++) {
        NSString *t1 = self.buttonTitles[i];
        if ([action.title isEqualToString:t1]) {
            if (self.selectedBlock) {
                self.selectedBlock(self, i);
            }
            break;
        }
    }
}


-(void)showWithSelectedBlcok:(SCAlertControllerSelectedBlock)selectedBlock;
{
    self.selectedBlock = selectedBlock;
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    if (!vc) {
        vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    [vc presentViewController:self.alertController animated:YES completion:nil];
}

-(void)dismiss
{
    [self.alertController dismissViewControllerAnimated:YES completion:nil];
}

@end
