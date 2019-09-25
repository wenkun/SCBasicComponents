//
//  SHDTListController.m
//  Robot
//
//  Created by 星星 on 2018/7/11.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHDTListController.h"
#import "SHDTLANDeviceListController.h"
#import "SHDebugTool.h"
#import "SCNetworking.h"
#import "SHDTHttpDeviceModel.h"
#import "SHDTCloudDeviceListController.h"
#import "SHHomeUser.h"
#import "SHDTHttpDeviceModel.h"
#import "SHHttpDeviceModel.h"
#import "SHDeviceManager.h"
#import "SCDevice.h"




@interface SHDTListController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property(nonatomic,strong) NSMutableArray *titles;
@property(nonatomic,strong) NSMutableArray *classNames;
///用户云平台设备列表
@property (strong, nonatomic) NSArray<SHDTHttpDeviceModel *> *cloudDevList;
///家庭服务器有但是云平台没有的设备列表
@property (strong, nonatomic) NSArray<SHHttpDeviceModel *> *errorDeviceList;
@end

@implementation SHDTListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Debug汇总";
    self.titles = [NSMutableArray array];
    self.classNames = [NSMutableArray array];
    [self configNavigationBar];
    [self addCellWithTitle:@"uSDK设备列表" class:@"SHDTLANDeviceListController"];
    [self addCellWithTitle:@"请求列表" class:@"SHDTRequestListController"];
    [self addCellWithTitle:@"appDebug测试开关" class:@"SHDTAppDebugSwitchController"];
    [self addCellWithTitle:[NSString stringWithFormat:@"当前是%@APP",EnvirementTag == ProductEnv ? @"生产":@"非生产"] class:@""];
    if (![SHHomeUser currentUser].isTourist) {
        [self gainCloudDeviceList];
    }
    
    [[SHDebugTool sharedInstance] hideWindow];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SHHttpDeviceModel *getewayDevice = [SHDeviceManager currentGetewayDevice];
    if (getewayDevice) {
        [self addCellWithTitle:@"网关授权状态" class:@""];
        
    }else{
        [self deleteCellWithTitle:@"网关授权状态" class:@""];
    }
}
- (void)dealloc{
    //    [[SHDebugTool sharedInstance] showWindow];
}
#pragma mark - Action

- (void)addCellWithTitle:(NSString *)title class:(NSString *)className{
    if (![self.titles containsObject:title]) {
        [self.titles addObject:title];
        [self.classNames addObject:className];
    }
    if (_mTableView) {
        [_mTableView reloadData];
    }
}
- (void)deleteCellWithTitle:(NSString *)title class:(NSString *)className{
    [self.titles removeObject:title];
    [self.classNames removeObject:className];
    if (_mTableView) {
        [_mTableView reloadData];
    }
}

/**
 导航栏按钮设置
 */
- (void)configNavigationBar{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"关闭" forState:UIControlStateNormal];
    [rightButton setTitleColor:ColorWithHex(@"333333") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}
- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[SHDebugTool sharedInstance] showWindow];
}
- (void)findErrorMac{
    NSMutableArray *homeServerMacs = [NSMutableArray array];
    NSArray *homeDeviceList = [SHDeviceManager defaultManager].deviceList;
    for (SHHttpDeviceModel *httpDevice in homeDeviceList) {
        [homeServerMacs addObject:httpDevice.deviceMac];
    }
    
    NSMutableArray *cloudMacs = [NSMutableArray array];
    for (SHDTHttpDeviceModel *httpDevice in self.cloudDevList) {
        [cloudMacs addObject:httpDevice.deviceId];
    }
    NSMutableArray *errorMacs = [NSMutableArray array];
    for (NSString *mac in homeServerMacs) {
        if (![cloudMacs containsObject:mac]) {
            [errorMacs addObject:mac];
        }
    }
    if (errorMacs.count>0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.deviceMac in %@",errorMacs];
        self.errorDeviceList = [homeDeviceList filteredArrayUsingPredicate:predicate];
        
        [self addCellWithTitle:@"设备列表有云平台没有" class:@"none"];
    }else{
        [self deleteCellWithTitle:@"设备列表有云平台没有" class:@"none"];
    }
}
#pragma mark - network
- (void)gainCloudDeviceList{
    NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970]*1000)];
    NSString *host = @"https://uws.haier.net";
    NSString *urlPath = @"/uds/v1/protected/deviceinfos";
    NSString *appId = ROBOT_APPID;
    NSString *appKey = ROBOT_APPKEY;
    NSString *unSignedString = [NSString stringWithFormat:@"%@%@%@%@",urlPath,appId,appKey,timestamp];
    NSString *signedString = [unSignedString sha256String];
    NSDictionary *header = @{
                             @"sign":signedString,
                             @"language":@"zh-cn",
                             @"timezone":@"+8",
                             @"timestamp":timestamp,
                             @"clientId":[SHHomeUser currentUser].clientId,
                             @"appId":appId,
                             @"appKey":appKey,
                             @"sequenceId":timestamp,
                             @"appVersion":[UIApplication sharedApplication].appVersion,
                             //@"accessToken":[UserAccount currentAccount].accessToken,
                             @"accessToken":[SHHomeUser currentUser].uhomeAccessToken,
                             };
    NSString *url = [NSString stringWithFormat:@"%@%@",host,urlPath];
    __weak typeof(self) weakSelf = self;
    [SCNetworking get:url header:header parameters:nil completionSuccess:^(NSURLResponse *response, NSDictionary *responseDictionary) {
        weakSelf.cloudDevList = [SHDTHttpDeviceModel analyzingWithArrayData:responseDictionary[@"deviceinfos"]];
        [weakSelf addCellWithTitle:@"用户云平台设备列表" class:@"SHDTCloudDeviceListController"];
        [self findErrorMac];
    } failed:^(NSURLResponse *response, NSError *error) {
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"UITableViewCell-UITableViewCellStyleValue1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    NSString *title = _titles[indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.numberOfLines = 0;
    if ([title isEqualToString:@"用户云平台设备列表"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%ld)",title,self.cloudDevList.count];

    }else if ([title isEqualToString:@"设备列表有云平台没有"]){
        NSMutableString *info = [NSMutableString stringWithFormat:@"%@(",title];
        for (SHHttpDeviceModel *device in self.errorDeviceList) {
            [info appendFormat:@"%@ %@,",device.deviceName,device.deviceMac];
        }
        [info appendString:@")"];
        cell.textLabel.text = info;
    }
    else if ([title isEqualToString:@"网关授权状态"]){
        __block NSString *state = @"未知";
        SHHttpDeviceModel *getewayDevice = [SHDeviceManager currentGetewayDevice];
        if (getewayDevice) {
            SCDevice *device = [SCDevice deviceWithHttpDevice:getewayDevice];
            [device getDeviceAuthStateSuccess:^(BOOL authState) {
                state = @"已授权";
                cell.textLabel.text = [NSString stringWithFormat:@"当前网关授权状态： %@",state];
            } failure:^(NSError *error) {
                state = error.localizedDescription;
                cell.textLabel.text = [NSString stringWithFormat:@"当前网关授权状态： %@",state];
            }];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"当前网关授权状态： %@",state];
    }
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.titles[indexPath.row];
    if ([title isEqualToString:@"设备列表有云平台没有"]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        pasteboard.string = cell.textLabel.text;
        [SCProgressHUD showMessage:@"复制成功"];
        return;
    }
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if ([className isEqualToString:@"SHDTCloudDeviceListController"]) {
        SHDTCloudDeviceListController *vc = class.new;
        vc.title = [NSString stringWithFormat:@"%@(%ld)",_titles[indexPath.row],self.cloudDevList.count];
        vc.deviceList = self.cloudDevList;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

@end
