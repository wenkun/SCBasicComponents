//
//  SHSevenDayView.m
//  Robot
//
//  Created by haier on 2019/5/31.
//  Copyright © 2019 Haier. All rights reserved.
//

#import "SHSevenDayView.h"
#import "SHOneDayViw.h"
#import "NSDate+SCExtension.h"

@interface SHSevenDayView()
@property(nonatomic,strong)NSMutableArray* items;

@end

@implementation SHSevenDayView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI:frame];
    }
    return self;
}

-(void)setupUI:(CGRect)frame
{
    
    CGFloat item_w = frame.size.width/7;
    self.items = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<7; i++) {
        SHOneDayViw* one = [[SHOneDayViw alloc] initWithFrame:CGRectMake(i*item_w, 0, item_w, frame.size.height)];
        one.tag = i;
        UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [one addGestureRecognizer:oneTap];
        
        [self addSubview:one];
        [self.items addObject:one];
    }
}

-(void)setStartDate:(NSDate*)startDate
{
    for (int i = 0; i<7; i++) {
        SHOneDayViw* one = [self.items objectAtIndex:i];
        NSDate* oneDate = [startDate dateByAddingDays:i];
        [one setContentDate:oneDate];
    }
}
-(CGFloat)getContentH
{
    SHOneDayViw* one = [self.items objectAtIndex:0];
    return one.contentV.frame.origin.y-5;
}
-(void)setEndDate:(NSDate*)startDate
{
    for (int i = 0; i<7; i++) {
        SHOneDayViw* one = [self.items objectAtIndex:i];
        NSDate* oneDate = [startDate dateByAddingDays:i-6];
        
        [one setContentDate:oneDate];
    }
}

-(NSDate*)getEndDate
{
    SHOneDayViw* one = [self.items objectAtIndex:6];
    return [one getCurDay];
}
-(NSDate*)getStartDate
{
    SHOneDayViw* one = [self.items objectAtIndex:0];
    return [one getCurDay];
}

-(void)didTap:(UITapGestureRecognizer*)tap
{
    for (int i = 0; i<7; i++) {
        SHOneDayViw* one = [self.items objectAtIndex:i];
        [one setDefaultState];
    }
    SHOneDayViw* one = (SHOneDayViw*)[tap view];
    [one setSelectedState];
    
    if (self.delegate) {
        [self.delegate didSelectSevenDayViewDate:[one getCurDay] inView:self];
    }
}
-(void)selectItem:(NSInteger)row
{
    for (int i = 0; i<7; i++) {
        SHOneDayViw* one = [self.items objectAtIndex:i];
        if (i==row) {
            [one setSelectedState];
        }
        else
        {
            [one setDefaultState];
        }
        
    }
}
@end
