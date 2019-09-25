//
//  SCStylelsTableViewCell.m
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/2.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SCStylelsTableViewCell.h"

@implementation SCStylelsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomLine.backgroundColor = ColorLine;
    self.lineLeading = 18;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.selectedView.highlighted = YES;
    }
    else {
        self.selectedView.highlighted = NO;
    }
}

@end
