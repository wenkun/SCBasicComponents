//
//  SHTableViewCell.m
//  Robot
//
//  Created by 文堃 杜 on 2018/6/27.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHTableViewCell.h"

@interface SHTableViewCell ()
{
    UIView *_bottomLine;
}
@end

@implementation SHTableViewCell

-(instancetype)init
{
    if (self = [super init]) {
        [self initLineData];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initLineData];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initLineData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_bottomLine) {
        [self updateBottomLineConstraints];
    }
}

#pragma mark - UI

-(void)initLineData
{
    _lineTrailing = 0;
    _lineLeading = 0;
    _lineHeight = 1.;
}

-(void)updateBottomLineConstraints
{
    [self.contentView bringSubviewToFront:self.bottomLine];
    self.bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomLine.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:self.lineLeading].active = YES;
    [self.bottomLine.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:self.lineTrailing].active = YES;
    [self.bottomLine.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:0].active = YES;
    [self.bottomLine.heightAnchor constraintEqualToConstant:self.lineHeight].active = YES;
}

#pragma mark - Porperty

-(UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = ColorWithHex(@"e4e4e4");
        [self.contentView addSubview:_bottomLine];
    }
    return _bottomLine;
}

//-(void)setLineLeading:(CGFloat)lineLeading
//{
//    _lineLeading = lineLeading;
//    [self updateBottomLineConstraints];
//}
//
//-(void)setLineTrailing:(CGFloat)lineTrailing
//{
//    _lineTrailing = lineTrailing;
//    [self updateBottomLineConstraints];
//}
//
//-(void)setLineHeight:(CGFloat)lineHeight
//{
//    _lineHeight = lineHeight;
//    [self updateBottomLineConstraints];
//}


@end
