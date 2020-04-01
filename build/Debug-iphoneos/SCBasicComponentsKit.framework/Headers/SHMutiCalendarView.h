//
//  SHMutiCalendarView.h
//  Robot
//
//  Created by haier on 2019/5/29.
//  Copyright © 2019 Haier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SHMutiCalendarViewDelegate <NSObject>

-(void)didSelectedDate:(NSDate*)date;
-(void)didShowBigCalendar:(CGSize)size;
-(void)didHideBigCalendar;
@end

@interface SHMutiCalendarView : UIView
@property(nonatomic,weak) id<SHMutiCalendarViewDelegate>delegate;

-(void)setCalendarViewY:(CGFloat)y;
-(void)hideView;
-(void)setParentController:(UIViewController*)ctl;

-(void)setSelectedDate:(NSDate*)date;
@end

NS_ASSUME_NONNULL_END
