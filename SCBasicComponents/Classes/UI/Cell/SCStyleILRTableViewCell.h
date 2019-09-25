//
//  SCStyleILRTableViewCell.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/6.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SHTableViewCell.h"

/**
 样式为（Image - Label - label - ArrowsImage）的cell
 */
@interface SCStyleILRTableViewCell : SHTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel; //默认text为nil
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@end
