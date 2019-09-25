//
//  SHDTWindowRootController.m
//  Robot
//
//  Created by 星星 on 2018/7/11.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHDTWindowRootController.h"
#import "SHDTListController.h"
#import "SHDebugTool.h"

@interface SHDTWindowRootController ()
@property (weak, nonatomic) IBOutlet UILabel *mLabel;

@end

@implementation SHDTWindowRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mLabel.font = FONT_SIZE(14);
    self.view.backgroundColor = [UIColor clearColor];
    self.mLabel.userInteractionEnabled = YES;
    self.mLabel.backgroundColor = [UIColor orangeColor];
    [self addGestureRecognizer];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    self.mLabel.layer.cornerRadius = 50;
}
- (void)addGestureRecognizer{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    [self.mLabel addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
    [self.mLabel addGestureRecognizer:tap];
    
}
#pragma mark - property

- (void)setFps:(CGFloat)fps{
    _fps = fps;
    _mLabel.text = [NSString stringWithFormat:@"FPS:%.0f",_fps];
}
#pragma mark - Action
- (void)panGR:(UIPanGestureRecognizer *)gr {
        CGPoint panPoint = [gr locationInView:[[UIApplication sharedApplication] keyWindow]];
        if (gr.state == UIGestureRecognizerStateBegan)
        {
        } else if (gr.state == UIGestureRecognizerStateChanged) {
            self.view.window.center = panPoint;
        } else if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled || gr.state == UIGestureRecognizerStateFailed) {
        }
}
- (void)tapGR:(UITapGestureRecognizer *)gr {
    
    UIViewController* vc = [[[UIApplication sharedApplication].delegate window] rootViewController];
    UIViewController* vc2 = vc.presentedViewController;
    SHDTListController *listVc = [[SHDTListController alloc] init];
    
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:listVc];
    [vc2?:vc presentViewController:navVc animated:YES completion:nil];
    
}
@end
