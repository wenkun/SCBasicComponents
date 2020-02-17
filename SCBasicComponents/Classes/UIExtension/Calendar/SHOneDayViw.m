//
//  SHOneDayViw.m
//  Robot
//
//  Created by haier on 2019/5/31.
//  Copyright © 2019 Haier. All rights reserved.
//

#import "SHOneDayViw.h"
#import "SCDefaultsUI.h"

@interface SHOneDayViw()
@property(nonatomic,strong)NSDate* date;
@property(nonatomic,strong)UILabel* monthL;
@property(nonatomic,strong)UILabel* dayL;
@property(nonatomic,strong)UILabel* weekdayL;


@end

@implementation SHOneDayViw


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupUIWith:frame];
    }
    
    return self;
}

-(void)setupUIWith:(CGRect)rect
{
    CGSize size = rect.size;
    CGFloat contentW = size.width;
    if (contentW>size.height-20) {
        contentW = size.height-20;
    }
    contentW = contentW* 0.8;

    
    self.contentV = [[UIView alloc] initWithFrame:CGRectMake((size.width-contentW)/2, (size.height-contentW-20)/2+20, contentW, contentW)];
    [self addSubview:self.contentV];
    self.contentV.layer.cornerRadius = 10;
    self.weekdayL = [[UILabel alloc] initWithFrame:CGRectMake(self.contentV.frame.origin.x, self.contentV.frame.origin.y-20, self.contentV.frame.size.width, 15)];
    self.weekdayL.font = [UIFont systemFontOfSize:10];
    self.weekdayL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.weekdayL];
    
    
    
    self.dayL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentV.frame.size.width, self.contentV.frame.size.height/2)];
    self.monthL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.dayL.frame.size.height, self.contentV.frame.size.width, self.contentV.frame.size.height-self.dayL.frame.size.height)];
    
    self.dayL.textAlignment = NSTextAlignmentCenter;
    self.monthL.textAlignment = NSTextAlignmentCenter;
    
    self.dayL.font = [UIFont systemFontOfSize:14];
    self.monthL.font = [UIFont systemFontOfSize:10];
    
    
    [self.contentV addSubview:self.dayL];
    [self.contentV addSubview:self.monthL];
    
    [self setDefaultState];
    
}
-(NSString*)getWeekDayStrBy:(NSInteger)i
{
    NSString* weekdayStr = @"日";
    if (i==0) {
        weekdayStr = @"日";
    }
    else if(i==1)
    {
        weekdayStr = @"一";
    }
    else if(i==2)
    {
        weekdayStr = @"二";
    }
    else if(i==3)
    {
        weekdayStr = @"三";
    }
    else if(i==4)
    {
        weekdayStr = @"四";
    }
    else if(i==5)
    {
        weekdayStr = @"五";
    }
    else if(i==6)
    {
        weekdayStr = @"六";
    }
    return weekdayStr;
}
-(void)setSelectedState
{
    self.dayL.textColor = ColorWithHex(@"ffffff");
    self.monthL.textColor = ColorWithHex(@"ffffff");
    self.contentV.backgroundColor = ColorWithHex(@"5F84EE");
    self.weekdayL.textColor = ColorWithHex(@"AAAAAA");
}
-(void)setDefaultState
{
    self.dayL.textColor = ColorWithHex(@"333333");
    self.monthL.textColor = ColorWithHex(@"AAAAAA");
    self.contentV.backgroundColor = ColorWithHex(@"ffffff");
    self.weekdayL.textColor = ColorWithHex(@"AAAAAA");
    
}
-(void)setDisableState
{
    self.dayL.textColor = ColorWithHex(@"999999");
    self.monthL.textColor = ColorWithHex(@"AAAAAA");
    self.contentV.backgroundColor = ColorWithHex(@"ffffff");
    self.weekdayL.textColor = ColorWithHex(@"AAAAAA");
}

-(void)setContentDate:(NSDate*)date
{
    self.date = date;
    NSDateComponents* cmps = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    self.dayL.text = [NSString stringWithFormat:@"%ld",cmps.day];
    self.monthL.text = [NSString stringWithFormat:@"%ld月",cmps.month];
    self.weekdayL.text = [self getWeekDayStrBy:cmps.weekday-1];
    
    [self setDefaultState];
                             
}
-(NSDate*)getCurDay
{
    return self.date;
}
@end
