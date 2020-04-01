//
//  SHCalendarView.h
//  Robot
//
//  Created by haier on 2019/6/5.
//  Copyright © 2019 Haier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SHCalendarViewDelegate <NSObject>

-(void)didSelectedCalendarViewDate:(NSDate*)selectedDate;
-(void)didChangeCalendarViewMonth:(NSDate*)curMonth;
-(void)panSHCalendarViewAction:(UIPanGestureRecognizer*)pan;
@end
@interface SHCalendarView : UIView
@property(nonatomic, weak)id<SHCalendarViewDelegate>delegate;
@property(nonatomic,assign)BOOL canShowFurture;//是否可以选择未来时间
@property(nonatomic,strong)NSMutableArray* onlineList;

-(void)setDate:(NSDate*)date;

-(void)leftClick;
-(void)rightClick;
@end

NS_ASSUME_NONNULL_END
