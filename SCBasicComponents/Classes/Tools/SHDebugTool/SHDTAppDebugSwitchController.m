//
//  SHDTAppDebugSwitchController.m
//  Robot
//
//  Created by 星星 on 2018/11/16.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHDTAppDebugSwitchController.h"
#import "NBSDKManager.h"

@interface SHDTAppDebugSwitchController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation SHDTAppDebugSwitchController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (void)uSDKLogSwitch:(UISwitch *)sender{
    [NBSDKManager defaultManager].logLevel = sender.isOn ? NBLogLevelDebug:NBLogLevelNone;
    
    NBLogLevel level = [NBSDKManager defaultManager].logLevel;
    NSString *message = level==NBLogLevelDebug ? @"NBSDKlog 打开":@"NBSDKlog 关闭";
    [SCProgressHUD showMessage:message];
}

- (void)saveLogFileSwitch:(UISwitch *)sender{
    [[SCLogManager share] startLogAndWriteToFile];
    [SCProgressHUD showMessage:@"log开始写入到本地"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID= @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row==0) {
        cell.textLabel.text = @"开管NBSDKLog最高等级";
        UISwitch *mSwitch = [[UISwitch alloc] init];
        [mSwitch addTarget:self action:@selector(uSDKLogSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView  = mSwitch;
        NBLogLevel level = [NBSDKManager defaultManager].logLevel;
        mSwitch.on = level==NBLogLevelDebug;
    }
    if (indexPath.row==1) {
        cell.textLabel.text = @"log是否写入本地";
        UISwitch *mSwitch = [[UISwitch alloc] init];
        [mSwitch addTarget:self action:@selector(saveLogFileSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView  = mSwitch;
        cell.detailTextLabel.text = @"会调用[SCLogManager startLogAndWriteToFile];";
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

@end
