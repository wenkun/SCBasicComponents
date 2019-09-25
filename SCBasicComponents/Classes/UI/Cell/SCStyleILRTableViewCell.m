//
//  SCStyleILRTableViewCell.m
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/6.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SCStyleILRTableViewCell.h"

@implementation SCStyleILRTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bottomLine.backgroundColor = ColorLine;
    self.lineLeading = 18;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
