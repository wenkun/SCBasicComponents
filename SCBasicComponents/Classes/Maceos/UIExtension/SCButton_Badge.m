//
//  SCButton_Badge.m
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/9.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#define BadgeViewHeight 16.

#import "SCButton_Badge.h"

//@interface BadgeLabel : UILabel
//@end
//@implementation BadgeLabel
//- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
//{
//    return [super textRectForBounds:CGRectMake(bounds.origin.x-4, bounds.origin.y, bounds.size.width+8, bounds.size.height) limitedToNumberOfLines:numberOfLines];
//}
//@end

@interface SCButton_Badge ()

@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation SCButton_Badge

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

-(void)updateConstraints
{
    [super updateConstraints];
    [self initBadgeView];
}

-(CGFloat)badgeHeight
{
    if (_badgeHeight == 0) {
        _badgeHeight = BadgeViewHeight;
    }
    return _badgeHeight;
}

-(UILabel *)badgeLabel
{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.font = [UIFont systemFontOfSize:10];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.hidden = YES;
    }
    return _badgeLabel;
}

-(void)initBadgeView
{
    if (!self.badgeLabel.superview) {
        [self addSubview:self.badgeLabel];
        self.badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.badgeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:14]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.badgeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-14]];
        [self.badgeLabel.heightAnchor constraintEqualToConstant:self.badgeHeight].active = YES;
        [self.badgeLabel.widthAnchor constraintGreaterThanOrEqualToConstant:self.badgeHeight].active = YES;
        self.badgeLabel.layer.cornerRadius = self.badgeHeight/2;
        self.badgeLabel.clipsToBounds = YES;
    }
}

-(void)setBadge:(NSString *)badge
{
    _badge = badge;
    self.badgeLabel.text = badge;
    if (!badge) {
        self.badgeLabel.hidden = YES;
    }
    else {//有数字的话就隐藏红点
        self.badgeLabel.hidden = NO;
    }
}

@end
