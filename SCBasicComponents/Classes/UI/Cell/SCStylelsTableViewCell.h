//
//  SCStylelsTableViewCell.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/2.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SHTableViewCell.h"

/**
 样式为（Label - SelectedImage）的cell
 */
@interface SCStylelsTableViewCell : SHTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedView;
@end
