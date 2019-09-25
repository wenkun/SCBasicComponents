//
//  SHTableViewCell.h
//  Robot
//
//  Created by 文堃 杜 on 2018/6/27.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHTableViewCell : UITableViewCell

///cell的底部分割新
@property (nonatomic, readonly) UIView *bottomLine;
///分割线距离左边的距离
@property (nonatomic, assign) CGFloat lineLeading;
///分割线距离右边的距离
@property (nonatomic, assign) CGFloat lineTrailing;
///分割线的高度，默认为1
@property (nonatomic, assign) CGFloat lineHeight;

@end
