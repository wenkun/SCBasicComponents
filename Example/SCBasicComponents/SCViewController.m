//
//  SCViewController.m
//  SCBasicComponents
//
//  Created by wenkun on 02/07/2018.
//  Copyright (c) 2018 wenkun. All rights reserved.
//

#import "SCViewController.h"
#import "SCBasicComponents.h"

@interface SCViewController () <UIPickerViewDataSource, UIPickerViewDelegate, SCLogManagerDelegate>

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [SCLogManager share].delegate = self;
    
    
    NSLog(@"%@", @(ScreenHeight));
    NSLog(@"%@", @(self.view.frame.size.height));
    
//    UIColor *color = RGBA(110, 110, 110, 1);
//    UIColor *color = ColorWithHex(@"123456");
//    self.view.backgroundColor = color;
    
//    [NSUserDefaults standardUserDefaults]

    [self testPath];
    [self testLog];
    [self testUIApplication];
//    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
//    [image imageByRoundCornerRadius:5];
//    [image imageByRoundCornerRadius:5 borderWidth:2 borderColor:[UIColor redColor]];
//    [image imageByRoundCornerRadius:3 corners:0 borderWidth:2 borderColor:[UIColor redColor] borderLineJoin:kCGLineJoinRound];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SCAppJump telPhone:@"18612032019"];
//    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED
{
    return [NSString stringWithFormat:@"%ld", row];
}

#pragma mark - test

- (void)testUIApplication{
//    UIApplication *app = [UIApplication sharedApplication];
//    NSURL *documentsURL = app.documentsURL;
//    NSString *documentsPath = app.documentsPath;
//    
//    NSURL *cachesURL = app.cachesURL;
//    NSString *cachesPath = app.cachesPath;
//    
//    NSURL *libraryURL = app.libraryURL;
//    NSString *libraryPath = app.libraryPath;
//    NSString *appBuildVersion = app.appBuildVersion;
//    
//    NSString *appVersion = app.appVersion;
//    NSString *appBundleID = app.appBundleID;
//    NSString *appBundleName = app.appBundleName;
//    
//    int64_t memoryUsage = app.memoryUsage;
//    float cpuUsage = app.cpuUsage;
//    
//    BOOL isAppExtension = [UIApplication isAppExtension];
//    
//    UIApplication *sharedExtensionApplication = [UIApplication sharedExtensionApplication];
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
    static NSInteger index = 0;
    index ++;
    SCLog(@"[APP]%@", [UIDevice deviceMode]);
    SCLog(@"[TEST] Just a Test [%@]", @(index));
    SCDebugLog(@"Can you find me?");
    //Log写入本地
    [SCLogManager startLogAndWriteToFile];
        
    index ++;
    SCLog(@"[APP]%@", [UIDevice deviceMode]);
    SCLog(@"[TEST] Just a Test");
    SCDebugLog(@"Can you find me?");
    
    NSString *path = [SCLogManager share].logFilePaths.lastObject;
    NSError *error;
    NSString *log = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    SCLog(@"LiCENSE : >>>>> %@", log);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testLog];
    });
}

-(void)test
{
    [self.view.topAnchor constraintEqualToAnchor:self.view.topAnchor];
}
- (IBAction)popPickerView:(id)sender
{
    SCAreaChoiseView *pv = [[SCAreaChoiseView alloc] init];
    pv.pickerView.dataSource = self;
    pv.pickerView.delegate = self;
//    pv.backgroudView.hidden = YES;
//    pv.topBar.hidden = YES;
    [pv showInView:self.view animation:YES];
    
    
    
}

#pragma mark - log

-(NSString *)logFileName
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyyMMdd HHmmss +0800.txt";
//    NSString *name = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *name = [NSString stringWithFormat:@"%@", @([[NSDate date] timeIntervalSince1970])];
    name = [name stringByAppendingPathExtension:@"txt"];
    
    return name;
}

-(NSString *)logHeaderAppending
{
    return [NSString stringWithFormat:@" User : %@ \n", @"18612345678"];
}

@end
