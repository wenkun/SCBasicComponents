//
//  SHCalenderSelectView.m
//  Robot
//
//  Created by haier on 2018/12/20.
//  Copyright © 2018 Haier. All rights reserved.
//

#import "SHCalendarSelectView.h"
#import "SHLabelCollectionViewCell.h"
#import "SHCalendarFlowLayout.h"
#import "SCDefaultsUI.h"
#import "NSDate+SCExtension.h"


@interface SHCalendarSelectView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,retain)UILabel* titleL;
@property(nonatomic,retain)NSCalendar* calendar;
@property(nonatomic,assign)NSInteger mounthOffset;
@property(nonatomic,retain)NSMutableArray* mounthDateArray;
@property(nonatomic,assign)NSInteger currentDay;
@property(nonatomic,retain)UICollectionView* calendarView;
@property(nonatomic,retain)SHCalendarFlowLayout*flowLayout;
@property(nonatomic,retain)UIButton* rightBtn;
@end

@implementation SHCalendarSelectView


+(SHCalendarSelectView*)shareInstance
{
    static dispatch_once_t onceToken;
    static SHCalendarSelectView* calendarObj;
    dispatch_once(&onceToken, ^{
        calendarObj = [[SHCalendarSelectView alloc] init];
        [calendarObj initView];
        [calendarObj initData];
    });
    
    return calendarObj;
}
-(void)initData
{
    self.mounthOffset = 0;
    self.canShowFurture = YES;
    self.mounthDateArray = [[NSMutableArray alloc] init];
    
}
-(void)initView
{
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    
    //内容
    _contentV = [[UIView alloc] init];
    _contentV.backgroundColor = [UIColor whiteColor];
    _contentV.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    //头
    UIView* headerView = [[UIView alloc] init];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    headerView.backgroundColor = ColorWithHex(@"e6e6e6");
    
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;

    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ColorWithHex(@"1464f7") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _titleL = [[UILabel alloc] init];
    _titleL.textColor = ColorWithHex(@"333333");
    _titleL.font = [UIFont systemFontOfSize:16];
    _titleL.textAlignment = NSTextAlignmentCenter;
    _titleL.translatesAutoresizingMaskIntoConstraints = NO;

    
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"btn_left_arrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.translatesAutoresizingMaskIntoConstraints = NO;

    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setImage:[UIImage imageNamed:@"btn_right_arrow"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.translatesAutoresizingMaskIntoConstraints = NO;

    //日历
    _flowLayout = [[SHCalendarFlowLayout alloc] init];
    
    _calendarView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _calendarView.delegate = self;
    _calendarView.dataSource = self;
    
    [_calendarView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_calendarView registerNib:[UINib nibWithNibName:@"SHLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SHLabelCollectionViewCell"];
    _calendarView.translatesAutoresizingMaskIntoConstraints = NO;

    
    //布局
    [self addSubview:_contentV];
    
    [_contentV addSubview:headerView];
    [_contentV addSubview:_calendarView];
    
    [headerView addSubview:_titleL];
    [headerView addSubview:cancelBtn];
    [headerView addSubview:leftBtn];
    [headerView addSubview:_rightBtn];
    
    
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_contentV,headerView,cancelBtn,_titleL,_rightBtn,leftBtn,_calendarView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentV]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentV(390)]-0-|" options:0 metrics:nil views:views]];
    
    [_contentV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_calendarView]-0-|" options:0 metrics:nil views:views]];
    [_contentV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerView]-0-|" options:0 metrics:nil views:views]];
    [_contentV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerView(50)]-0-[_calendarView]-0-|" options:0 metrics:nil views:views]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[cancelBtn(60)]" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[cancelBtn(40)]" options:0 metrics:nil views:views]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_titleL attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:110]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_titleL attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_titleL(40)]-5-|" options:0 metrics:nil views:views]];

    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[leftBtn(40)]-5-|" options:0 metrics:nil views:views]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:leftBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_titleL attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:leftBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:leftBtn attribute:NSLayoutAttributeHeight multiplier:21.0/36.0 constant:0]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_rightBtn(40)]-5-|" options:0 metrics:nil views:views]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_rightBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_titleL attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_rightBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_rightBtn attribute:NSLayoutAttributeHeight multiplier:21.0/36.0 constant:0]];
    
    
    
    
    
}
-(BOOL)isOnlineWith:(NSDate*)date
{
    BOOL rt = NO;
    if (self.onlineList) {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        for (NSDate* one in self.onlineList) {
            if ([calendar isDate:one equalToDate:date toUnitGranularity:NSCalendarUnitDay]) {
                rt = YES;
                break;
            }
        }
    }
    return rt;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint pos = [[touches anyObject] locationInView:self];
    if (pos.y<_contentV.frame.origin.y) {
        [self hideView];
    }
}
-(void)reloadUIData
{
    [self.calendarView reloadData];
}
-(void)setDate:(NSDate*)date
{
    NSDate* now = date;
    _currentDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:now];
    [self setCalendarViewDataSource:now];
    
    _titleL.text = [self getTitleFrom:now];
    
    if (_canShowFurture==NO)
    {
        if (_mounthOffset>=0) {
            _rightBtn.hidden = YES;
        }
        else
        {
            _rightBtn.hidden = NO;
        }
    }
}
-(void)showWithSelectedDate:(NSDate*)date
{
    
    [self setDate:date];
    UIWindow * win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:self];
    _contentV.alpha = 0;
    _contentV.transform = CGAffineTransformMakeTranslation(0, _contentV.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        self.contentV.alpha = 1;
        self.contentV.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.contentV.alpha = 1;
        self.contentV.transform = CGAffineTransformIdentity;
    }];
}

-(void)hideView
{
    _contentV.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentV.alpha = 0;
        self.contentV.transform = CGAffineTransformMakeTranslation(0, self.contentV.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)leftClick
{
    _mounthOffset = _mounthOffset-1;
    if(_mounthOffset==0)
    {
        NSDate* now = [NSDate date];
        _currentDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:now];
    }
    else
    {
        _currentDay = -1;
    }
    NSDate* now = [[NSDate date] dateByAddingMonths:_mounthOffset];
    [self setCalendarViewDataSource:now];
    
    _titleL.text = [self getTitleFrom:now];
    
    if (_canShowFurture==NO) {
        if (_mounthOffset>=0) {
            _rightBtn.hidden = YES;
        }
        else
        {
            _rightBtn.hidden = NO;
        }
    }
    
    if (_delegate) {
        [_delegate didChangeMonth:now];
    }
}
-(void)rightClick
{
    _mounthOffset = _mounthOffset + 1;
    
    if(_mounthOffset==0)
    {
        NSDate* now = [NSDate date];
        _currentDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:now];
    }
    else
    {
        _currentDay = -1;
    }
    NSDate* now = [[NSDate date] dateByAddingMonths:_mounthOffset];
    
    [self setCalendarViewDataSource:now];
    
    _titleL.text = [self getTitleFrom:now];
    if (_canShowFurture==NO)
    {
        if (_mounthOffset>=0) {
            _rightBtn.hidden = YES;
        }
        else
        {
            _rightBtn.hidden = NO;
        }
    }
    if (_delegate) {
        [_delegate didChangeMonth:now];
    }
}
-(NSString*)getTitleFrom:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM";
    
    return [formatter stringFromDate:date];
}
#pragma mark 日历
//根据date获取日
- (NSInteger)convertDateToDay:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    return [components day];
}

//根据date获取月
- (NSInteger)convertDateToMonth:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    return [components month];
}

//根据date获取年
- (NSInteger)convertDateToYear:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    return [components year];
}

//根据date获取当月周几 (美国时间周日-周六为 1-7,改为0-6方便计算)
- (NSInteger)convertDateToWeekDay:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:date];
    NSInteger weekDay = [components weekday] - 1;
    weekDay = MAX(weekDay, 0);
    return weekDay;
}

//根据date获取当月周几
- (NSInteger)convertDateToFirstWeekDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;  //美国时间周日为星期的第一天，所以周日-周六为1-7，改为0-6方便计算
}

-(NSInteger)getDaysOfMonth:(NSDate*)date
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    // 调用rangeOfUnit方法:(返回一样是一个结构体)两个参数一个大单位，一个小单位(.length就是天数，.location就是月)
    NSInteger monthNum = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    return monthNum;
}
-(NSInteger)getCurrentMonthForDays{
    return [self getDaysOfMonth:[NSDate date]];
}
-(NSInteger)getWeekDayFrom:(NSDate*)date
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSInteger weekday = [calendar component:NSCalendarUnitWeekday fromDate:date];
    return weekday;
}

-(void)setCalendarViewDataSource:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    NSInteger num = [self getDaysOfMonth:date];
    [self.mounthDateArray removeAllObjects];
    for (int i = 0; i<num; i++) {
        [comp setDay:i+1];
        NSDate* date = [calendar dateFromComponents:comp];
        [self.mounthDateArray addObject:date];
    }
    _flowLayout.datasource = self.mounthDateArray;

    [self.calendarView setCollectionViewLayout:_flowLayout];
    [self.calendarView reloadData];
}
#pragma mark UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger num = self.mounthDateArray.count;
    return num;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SHLabelCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHLabelCollectionViewCell" forIndexPath:indexPath];
    
    cell.textL.layer.cornerRadius = 25;
    cell.textL.clipsToBounds = YES;
    
    NSDate* date = [self.mounthDateArray objectAtIndex:indexPath.row];
    NSInteger day = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date];
    
    cell.textL.text = [NSString stringWithFormat:@"%ld",day];
    if (day==_currentDay) {
        cell.textL.backgroundColor = ColorWithHex(@"5f84ee");
        cell.textL.textColor = ColorWithHex(@"ffffff");
    }
    else
    {
        cell.textL.backgroundColor = ColorWithHex(@"ffffff");
        cell.textL.textColor = ColorWithHex(@"333333");
        
        //判断是否是在线日期
        if ([self isOnlineWith:date]==NO) {
            cell.textL.textColor = ColorWithHex(@"999999");
        }
        //判断是否是未来日期
        if (_canShowFurture==NO) {
            if ([date timeIntervalSinceNow]>0) {
                cell.textL.textColor = ColorWithHex(@"999999");
            }
        }
        
        
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isCanResponse = YES;
    NSDate* date = [self.mounthDateArray objectAtIndex:indexPath.row];
    //判断是否是在线日期
    if ([self isOnlineWith:date]==NO) {
        isCanResponse = NO;
    }
    //判断是否是未来日期
    if (_canShowFurture==NO) {
        if ([date timeIntervalSinceNow]>0) {
            isCanResponse = NO;
        }
        
    }
    if (isCanResponse) {
        _currentDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date];
        [collectionView reloadData];
        if (_delegate) {
            [_delegate didSelectedDate:date];
        }
    }
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        
        headerView.backgroundColor = [UIColor grayColor];
        
        for (UIView *subv in headerView.subviews) {
            [subv removeFromSuperview];
        }

        float width = [collectionView frame].size.width/7;
        UILabel* sun = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
        sun.text = @"日";
        sun.textColor = ColorWithHex(@"333333");
        sun.font = [UIFont systemFontOfSize:14];
        sun.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:sun];
        
        UILabel* mon = [[UILabel alloc] initWithFrame:CGRectMake(width, 0, width, 40)];
        mon.text = @"一";
        mon.textColor = ColorWithHex(@"333333");
        mon.font = [UIFont systemFontOfSize:14];
        mon.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:mon];
        
        UILabel* tues = [[UILabel alloc] initWithFrame:CGRectMake(width*2, 0, width, 40)];
        tues.text = @"二";
        tues.textColor = ColorWithHex(@"333333");
        tues.font = [UIFont systemFontOfSize:14];
        tues.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:tues];
        
        UILabel* wednes = [[UILabel alloc] initWithFrame:CGRectMake(width*3, 0, width, 40)];
        wednes.text = @"三";
        wednes.textColor = ColorWithHex(@"333333");
        wednes.font = [UIFont systemFontOfSize:14];
        wednes.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:wednes];
        
        UILabel* thurs = [[UILabel alloc] initWithFrame:CGRectMake(width*4, 0, width, 40)];
        thurs.text = @"四";
        thurs.textColor = ColorWithHex(@"333333");
        thurs.font = [UIFont systemFontOfSize:14];
        thurs.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:thurs];
        
        UILabel* fri = [[UILabel alloc] initWithFrame:CGRectMake(width*5, 0, width, 40)];
        fri.text = @"五";
        fri.textColor = ColorWithHex(@"333333");
        fri.font = [UIFont systemFontOfSize:14];
        fri.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:fri];
        
        UILabel* satur = [[UILabel alloc] initWithFrame:CGRectMake(width*6, 0, width, 40)];
        satur.text = @"六";
        satur.textColor = ColorWithHex(@"333333");
        satur.font = [UIFont systemFontOfSize:14];
        satur.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:satur];
        
        return headerView;
    }
    else
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        if(footerView == nil)
        {
            footerView = [[UICollectionReusableView alloc] init];
        }
        footerView.backgroundColor = [UIColor lightGrayColor];
        
        return footerView;
    }
    
}
@end
