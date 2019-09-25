//
//  SHDTRequestDetailController.m
//  Robot
//
//  Created by 星星 on 2018/7/13.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHDTRequestDetailController.h"

@interface SHDTRequestDetailController ()
@property (weak, nonatomic) IBOutlet UITextView *mTextView;

@end

@implementation SHDTRequestDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableString *logString = [[NSMutableString alloc] init];
    [logString appendFormat:@"时间：%@\n",_model.startDateString];
    [logString appendFormat:@"耗时：%@\n",_model.totalDuration];
    [logString appendFormat:@"URL：%@\n",_model.url];
    [logString appendFormat:@"header：%@\n",_model.headerFields];
    [logString appendFormat:@"parama：%@\n",_model.requestBody];
    [logString appendFormat:@"response：%@\n",_model.responseString];
    [logString appendFormat:@"isImage：%d\n",_model.isImage];
    if (_model.error) {
        [logString appendFormat:@"error：%@\n",_model.error];
    }
    
    _mTextView.text = logString;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
