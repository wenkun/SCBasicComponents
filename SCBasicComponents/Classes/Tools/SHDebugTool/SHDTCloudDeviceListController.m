//
//  SHDTCloudDeviceListController.m
//  Robot
//
//  Created by 星星 on 2018/8/6.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHDTCloudDeviceListController.h"
#import "SHDTHttpDeviceModel.h"
@interface SHDTCloudDeviceListController ()
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation SHDTCloudDeviceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    SHDTHttpDeviceModel *uDevice = [_deviceList objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    NSMutableString *info = [[NSMutableString alloc] init];
    [info appendFormat:@"型号名字:%@\n%@",uDevice.deviceName,uDevice.deviceId];
    cell.textLabel.text = info;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = uDevice.wifiType;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    pasteboard.string = [NSString stringWithFormat:@"%@\n%@",cell.textLabel.text,cell.detailTextLabel.text];
    [SCProgressHUD showMessage:@"复制成功"];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


@end
