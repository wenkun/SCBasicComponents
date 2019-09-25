//
//  SHDebugTool.h
//  Robot
//
//  Created by 星星 on 2018/7/11.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import <Foundation/Foundation.h>

static BOOL enble = YES;

/**
 仅仅显示一些调试信息，上线不会显示
 */
@class SHDTRequestModel;

@interface SHDebugTool : NSObject
///
@property (strong, nonatomic) NSMutableArray<SHDTRequestModel *> *requestArray;
+ (instancetype)sharedInstance;
- (void)startWorking;
- (void)showWindow;
- (void)hideWindow;
@end
