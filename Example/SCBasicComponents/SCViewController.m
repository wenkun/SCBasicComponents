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
    UIColor *color = ColorWithHex(@"123456");
    self.view.backgroundColor = color;
    
//    [NSUserDefaults standardUserDefaults]

    [self testPath];
    [self testLog];
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

-(void)testLog
{
    SCLog(@"[APP]%@", [UIDevice deviceMode]);
    SCLog(@"[TEST] Just a Test");
    SCDebugLog(@"Can you find me?");
    //Log写入本地
    [SCLogManager startLogAndWriteToFile];
    SCLog(@"[APP]%@", [UIDevice deviceMode]);
    SCLog(@"[TEST] Just a Test");
    SCDebugLog(@"Can you find me?");
}

@end
