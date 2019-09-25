//
//  SHDTCloudDeviceListController.h
//  Robot
//
//  Created by 星星 on 2018/8/6.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHDTHttpDeviceModel;
@interface SHDTCloudDeviceListController : UIViewController

///
@property (strong, nonatomic) NSArray<SHDTHttpDeviceModel *> *deviceList;
@end
