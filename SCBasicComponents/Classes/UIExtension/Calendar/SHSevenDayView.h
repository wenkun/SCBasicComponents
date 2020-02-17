//
//  SHSevenDayView.h
//  Robot
//
//  Created by haier on 2019/5/31.
//  Copyright © 2019 Haier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SHSevenDayView;

@protocol SHSevenDayViewDelegate <NSObject>

-(void)didSelectSevenDayViewDate:(NSDate*)date inView:(SHSevenDayView*)dayView;

@end

@interface SHSevenDayView : UIView
@property(nonatomic, strong)id<SHSevenDayViewDelegate>delegate;

-(void)setStartDate:(NSDate*)startDate;
-(void)setEndDate:(NSDate*)startDate;
-(void)selectItem:(NSInteger)row;

-(NSDate*)getEndDate;
-(NSDate*)getStartDate;

-(CGFloat)getContentH;
@end

NS_ASSUME_NONNULL_END
