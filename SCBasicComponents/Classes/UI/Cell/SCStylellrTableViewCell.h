//
//  SCStylellrTableViewCell.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/2.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SHTableViewCell.h"

/**
 样式为（Label - Label - ArrowsImage）的cell
 */
@interface SCStylellrTableViewCell : SHTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@end
