//
//  SHCalendarView.m
//  Robot
//
//  Created by haier on 2019/6/5.
//  Copyright © 2019 Haier. All rights reserved.
//

#import "SHCalendarView.h"
#import "SCDefaultsUI.h"
#import "SHLabelCollectionViewCell.h"
#import "NSDate+SCExtension.h"
#import "SHCalendarNoHeaderFlowLayout.h"

@interface SHCalendarView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,retain)UILabel* titleL;
@property(nonatomic,retain)NSCalendar* calendar;
@property(nonatomic,assign)NSInteger mounthOffset;
@property(nonatomic,retain)NSMutableArray* mounthDateArray;
@property(nonatomic,assign)NSInteger currentDay;
@property(nonatomic,retain)UICollectionView* calendarView;
@property(nonatomic,retain)SHCalendarNoHeaderFlowLayout*flowLayout;
@property(nonatomic,retain)UIButton* rightBtn;

@end

@implementation SHCalendarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupUI:frame];
    }
    return self;
}
-(void)initData
{
    self.mounthOffset = 0;
    self.canShowFurture = YES;
    self.mounthDateArray = [[NSMutableArray alloc] init];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSHCalendarViewAction:)];
    [self addGestureRecognizer:pan];
    
}
-(void)panSHCalendarViewAction:(UIPanGestureRecognizer*)pan
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(panSHCalendarViewAction:)]) {
        [self.delegate panSHCalendarViewAction:pan];
    }
}
-(void)setupUI:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
    //头
    UIView* headerView = [[UIView alloc] init];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    headerView.backgroundColor = ColorWithHex(@"ffffff");
        
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
    _flowLayout = [[SHCalendarNoHeaderFlowLayout alloc] init];
    
    _calendarView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _calendarView.delegate = self;
    _calendarView.dataSource = self;
    
    [_calendarView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_calendarView registerClass:[SHLabelCollectionViewCell class] forCellWithReuseIdentifier:@"SHLabelCollectionViewCell"];
//    [_calendarView registerNib:[UINib nibWithNibName:@"SHLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SHLabelCollectionViewCell"];
    _calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    //布局
    [self addSubview:headerView];
    [self addSubview:_calendarView];
    
    [headerView addSubview:_titleL];
    [headerView addSubview:leftBtn];
    [headerView addSubview:_rightBtn];
    
    
    NSDictionary* views = NSDictionaryOfVariableBindings(headerView,_titleL,_rightBtn,leftBtn,_calendarView);
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_calendarView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerView(40)]-0-[_calendarView]-20-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerView]-0-|" options:0 metrics:nil views:views]];

    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_titleL attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:110]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_titleL attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_titleL]-0-|" options:0 metrics:nil views:views]];
    
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[leftBtn]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:leftBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_titleL attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:leftBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:leftBtn attribute:NSLayoutAttributeHeight multiplier:21.0/36.0 constant:0]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_rightBtn]-0-|" options:0 metrics:nil views:views]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_rightBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_titleL attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_rightBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_rightBtn attribute:NSLayoutAttributeHeight multiplier:21.0/36.0 constant:0]];
    
}
-(void)setDate:(NSDate*)date
{
    NSDate* now = date;
    if ([[NSCalendar currentCalendar] isDateInToday:date]) {
        _mounthOffset = 0;
    }
    
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
        [_delegate didChangeCalendarViewMonth:now];
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
    NSDate* now = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMonth value:_mounthOffset toDate:[NSDate date] options:NSCalendarMatchFirst];
//    NSDate* now = [[NSDate date] dateByAddingMonths:_mounthOffset];
    
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
        [_delegate didChangeCalendarViewMonth:now];
    }
}
-(NSString*)getTitleFrom:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    
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
    
    cell.textL.layer.cornerRadius = 15;
    cell.textL.clipsToBounds = YES;
    
    NSDate* date = [self.mounthDateArray objectAtIndex:indexPath.row];
    NSInteger day = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date];
    
    cell.textL.text = [NSString stringWithFormat:@"%02ld",day];
    if (day==_currentDay) {
        cell.textL.backgroundColor = ColorWithHex(@"5f84ee");
        cell.textL.textColor = ColorWithHex(@"ffffff");
    }
    else
    {
        cell.textL.backgroundColor = ColorWithHex(@"ffffff");
        cell.textL.textColor = ColorWithHex(@"333333");
        
        //判断是否是在线日期
//        if ([self isOnlineWith:date]==NO) {
//            cell.textL.textColor = ColorWithHex(@"999999");
//        }
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
//    if ([self isOnlineWith:date]==NO) {
//        isCanResponse = NO;
//    }
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
            [_delegate didSelectedCalendarViewDate:date];
        }
    }
    
    
    [self removeFromSuperview];
    
}

@end
