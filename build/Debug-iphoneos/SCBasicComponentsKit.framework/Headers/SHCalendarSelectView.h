//
//  SHCalenderSelectView.h
//  Robot
//
//  Created by haier on 2018/12/20.
//  Copyright © 2018 Haier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SHCalendarSelectViewDelegate <NSObject>

-(void)didSelectedDate:(NSDate*)selectedDate;
-(void)didChangeMonth:(NSDate*)curMonth;
@end

@interface SHCalendarSelectView : UIView
@property(nonatomic, weak)id<SHCalendarSelectViewDelegate>delegate;
@property(nonatomic,assign)BOOL canShowFurture;//是否可以选择未来时间
@property(nonatomic,strong)NSMutableArray* onlineList;
@property(nonatomic,retain)UIView* contentV;

+(SHCalendarSelectView*)shareInstance;

-(void)setDate:(NSDate*)date;
-(void)showWithSelectedDate:(NSDate*)date;
-(void)reloadUIData;
-(void)hideView;
@end

NS_ASSUME_NONNULL_END
