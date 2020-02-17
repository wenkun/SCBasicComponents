//
//  SHLabelCollectionViewCell.m
//  Robot
//
//  Created by haier on 2018/12/20.
//  Copyright © 2018 Haier. All rights reserved.
//

#import "SHLabelCollectionViewCell.h"

@implementation SHLabelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (nil == self.textL.superview) {
        [self.contentView addSubview:self.textL];
        self.textL.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.textL.heightAnchor constraintEqualToAnchor:self.textL.widthAnchor],
            [self.textL.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [self.textL.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
        ]];
    }
}

- (UILabel *)textL
{
    if (!_textL) {
        _textL = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _textL.font = [UIFont systemFontOfSize:14];
        _textL.textAlignment = NSTextAlignmentCenter;
    }
    return _textL;
}

@end
