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
    [self testUIApplication];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SCAppJump telPhone:@"18612032019"];
//    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - test

- (void)testUIApplication{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *documentsURL = app.documentsURL;
    NSString *documentsPath = app.documentsPath;
    
    NSURL *cachesURL = app.cachesURL;
    NSString *cachesPath = app.cachesPath;
    
    NSURL *libraryURL = app.libraryURL;
    NSString *libraryPath = app.libraryPath;
    NSString *appBuildVersion = app.appBuildVersion;
    
    NSString *appVersion = app.appVersion;
    NSString *appBundleID = app.appBundleID;
    NSString *appBundleName = app.appBundleName;
    
    int64_t memoryUsage = app.memoryUsage;
    float cpuUsage = app.cpuUsage;
    
    BOOL isAppExtension = [UIApplication isAppExtension];
    
    UIApplication *sharedExtensionApplication = [UIApplication sharedExtensionApplication];
}
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
