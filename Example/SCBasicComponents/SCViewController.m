//
//  SCViewController.m
//  SCBasicComponents
//
//  Created by wenkun on 02/07/2018.
//  Copyright (c) 2018 wenkun. All rights reserved.
//

#import "SCViewController.h"
#import "SCBasicComponents.h"

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
    
//    [NSUserDefaults standardUserDefaults]

    [self testPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - test

-(void)testPath
{
    NSLog(@"%@",SCPathHome);
    NSLog(@"%@",SCPathLibrary);
    NSLog(@"%@",SCPathDocument);
    NSLog(@"%@",SCPathCaches);
    NSLog(@"%@",SCPathTmp);
    
    
}

@end
