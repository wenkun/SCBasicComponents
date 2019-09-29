//
//  SCButton_Badge.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/9.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SCButton.h"

@interface SCButton_Badge : SCButton

///设置消息数量，为nil时，不显示。
@property (nonatomic, strong) NSString *badge;
///默认是 16，根据需求修改
@property (nonatomic, assign) CGFloat badgeHeight;

@end
