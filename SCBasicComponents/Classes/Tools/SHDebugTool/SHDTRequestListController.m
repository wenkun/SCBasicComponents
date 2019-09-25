//
//  SHDTRequestListController.m
//  Robot
//
//  Created by 星星 on 2018/7/12.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHDTRequestListController.h"
#import "SHDebugTool.h"
#import "SHDTRequestModel.h"
#import "SHDTRequestDetailController.h"

@interface SHDTRequestListController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
///
@property (strong, nonatomic) NSArray<SHDTRequestModel *> *requestLogList;
@end

@implementation SHDTRequestListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请求列表";
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
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setTitle:@"清空" forState:UIControlStateNormal];
    [clearButton setTitleColor:ColorWithHex(@"333333") forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    [clearButton sizeToFit];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:rightButton],[[UIBarButtonItem alloc] initWithCustomView:clearButton],];
}
- (void)refreshDeviceList{
    _requestLogList = [SHDebugTool sharedInstance].requestArray;
    [_mTableView reloadData];
    [SCProgressHUD showMessage:@"刷新成功"];
}
- (void)clear{
    [[SHDebugTool sharedInstance].requestArray removeAllObjects];
    [self refreshDeviceList];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _requestLogList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID= @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SHDTRequestModel *requestModel = [_requestLogList objectAtIndex:indexPath.row];
    
    NSMutableString *logString = [[NSMutableString alloc] init];
    [logString appendFormat:@"时间：%@ Method:%@    %@",requestModel.startDateString,requestModel.method,requestModel.statusCode];
    cell.textLabel.font = FONT_SIZE(14);
    cell.textLabel.numberOfLines = 0;
    //    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.text = requestModel.url.absoluteString;
    cell.detailTextLabel.text = logString;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SHDTRequestModel *requestModel = [_requestLogList objectAtIndex:indexPath.row];
    SHDTRequestDetailController *vc = [[SHDTRequestDetailController alloc] init];
    vc.model = requestModel;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

@end
