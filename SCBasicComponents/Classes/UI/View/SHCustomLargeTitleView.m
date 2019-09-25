//
//  SHCustomLargeTitleView.m
//  Robot
//
//  Created by 星星 on 2018/6/6.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHCustomLargeTitleView.h"
#import "SCLogManager.h"

@implementation SHCustomLargeTitleView

+ (SHCustomLargeTitleView *)LargeTitleView{
    
    NSBundle *bundle = [NSBundle bundleForClass:[SHCustomLargeTitleView class]];
    return [bundle loadNibNamed:@"SHCustomLargeTitleView" owner:nil options:nil].firstObject;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    SCDebugLog(@"SHCustomLargeTitleView-awakeFromNib");
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    SCDebugLog(@"SHCustomLargeTitleView-initWithCoder");
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    SCDebugLog(@"SHCustomLargeTitleView-initWithFrame");
    return self;
}

- (void)setUp{
    
}

@end
