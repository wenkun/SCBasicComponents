//
//  SHDTLANDeviceListController.m
//  Robot
//
//  Created by 星星 on 2018/7/11.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHDTLANDeviceListController.h"
#import "SHDTLANDeviceDetailController.h"
#import "SHDeviceUIManager.h"
#import <uSDK/uSDKDeviceManager.h>
#import "SHDeviceManager.h"

@interface SHDTLANDeviceListController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
///
@property (strong, nonatomic) NSArray<uSDKDevice *> *deviceList;
@end

@implementation SHDTLANDeviceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"局域网设备列表";
    [self refreshDeviceList];
    [self configNavigationBar];;
    // Do any additional setup after loading the view from its nib.
}
/**
 导航栏按钮设置
 */
- (void)configNavigationBar{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"刷新" forState:UIControlStateNormal];
    [rightButton setTitleColor:ColorWithHex(@"333333") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(refreshDeviceList) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}
- (void)refreshDeviceList{
    _deviceList = [[uSDKDeviceManager defaultDeviceManager] getDeviceList];
    [_mTableView reloadData];
    [SCProgressHUD showMessage:@"刷新成功"];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _deviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID= @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    uSDKDevice *uDevice = [_deviceList objectAtIndex:indexPath.row];
    NSString *officeName = [SHDeviceUIManager deviceOfficialNameWithUplusID:uDevice.uplusID];
    NSString *imageString = [SHDeviceUIManager iconImageStringByTypeId:uDevice.uplusID];
    cell.imageView.image=  [UIImage imageNamed:imageString];
    cell.textLabel.numberOfLines = 0;
//    cell.detailTextLabel.numberOfLines = 0;
    
        
    NSString *status = @"离线";
    if (uDevice) {
        if (uDevice.state == uSDKDeviceStateReady) {
            status = @"就绪";
        } else if (uDevice.state == uSDKDeviceStateConnected) {
            status = @"已连接";
        } else if (uDevice.state == uSDKDeviceStateOffline) {
            status = @"离线";
        } else if (uDevice.state == uSDKDeviceStateConnecting) {
            status = @"正在连接";
        } else if (uDevice.state == uSDKDeviceStateUnconnect) {
            status = @"未连接";
        }
    }
    NSMutableString *info = [[NSMutableString alloc] init];
    [info appendFormat:@"型号名字:%@\n%@\n",officeName,uDevice.mac];
    [info appendFormat:@"在线状态：%@",status];
    if ([SHDeviceManager isAlreadyBindMac:uDevice.mac]) {
        [info appendString:@"  已绑定"];
    }
    cell.textLabel.text = info;
    cell.detailTextLabel.text = uDevice.uplusID;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    uSDKDevice *device = [_deviceList objectAtIndex:indexPath.row];
    SHDTLANDeviceDetailController *vc = [[SHDTLANDeviceDetailController alloc] init];
    vc.uDevice = device;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


@end
