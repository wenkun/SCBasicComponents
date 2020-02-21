//
//  SHMutiCalendarView.m
//  Robot
//
//  Created by haier on 2019/5/29.
//  Copyright © 2019 Haier. All rights reserved.
//

#import "SHMutiCalendarView.h"
#import "SHSevenDayView.h"
#import "SHCalendarSelectView.h"
#import "SHCalendarView.h"
#import "NSDate+SCExtension.h"

@interface SHMutiCalendarView()<SHSevenDayViewDelegate,SHCalendarViewDelegate>
@property(nonatomic,strong)SHCalendarView* bigCalendar;
@property(nonatomic,strong)SHSevenDayView* conV1;
@property(nonatomic,strong)SHSevenDayView* conV2;
@property(nonatomic,strong)SHSevenDayView* conV3;
@property(nonatomic,strong)NSArray* allV;
@property(nonatomic,assign)NSInteger item_w;//单元宽度
@property(nonatomic,assign)CGPoint startLoc;
@property(nonatomic,assign)CGFloat calendarY;

@property(nonatomic,assign)CGFloat startV1;
@property(nonatomic,assign)CGFloat startV2;
@property(nonatomic,assign)CGFloat startV3;

@property(nonatomic,strong)NSDate* curDate;
@property(nonatomic,assign)CGRect bigCalendarBeginRect;

@property(nonatomic,weak)UIViewController* ctl;
@end

@implementation SHMutiCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView:frame];
    }
    
    return self;
}
-(void)setupView:(CGRect)frame
{
    self.curDate = [NSDate date];
    self.conV1 = [[SHSevenDayView alloc] initWithFrame:CGRectMake(-frame.size.width, 0, frame.size.width, frame.size.height)];
    self.conV2 = [[SHSevenDayView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.conV3 = [[SHSevenDayView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
    
    [self addSubview:self.conV3];
    [self addSubview:self.conV2];
    [self addSubview:self.conV1];
    
    self.allV = @[self.conV1,self.conV2,self.conV3];
    
    NSDate* now  = [NSDate date];
    [self setSelectedDate:now];
    
    self.conV1.delegate = self;
    self.conV2.delegate = self;
    self.conV3.delegate = self;

    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
    
    self.bigCalendar = [[SHCalendarView alloc] initWithFrame:CGRectMake(0, 200, frame.size.width, 230)];
    self.bigCalendar.delegate = self;
    
}
-(void)setCalendarViewY:(CGFloat)y
{
    self.calendarY = y+[self.conV1 getContentH];
}
-(void)setSelectedDate:(NSDate*)date
{
    self.curDate = date;
    NSDateComponents*cmps = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday|NSCalendarUnitDay|NSCalendarUnitMonth fromDate:date];
    
    NSDate* lastDay  = [date dateByAddingDays:7-cmps.weekday];
    
    SHSevenDayView* left = [self getLeftView];
    SHSevenDayView* mid = [self getMidView];
    SHSevenDayView* right = [self getRightView];
    
    [left setEndDate:[lastDay dateByAddingDays:-7]];
    [mid setEndDate:lastDay];
    [right setStartDate:[lastDay dateByAddingDays:1]];
    
    [mid selectItem:cmps.weekday-1];
    [left selectItem:-1];
    [right selectItem:-1];
}
-(void)setParentController:(UIViewController*)ctl
{
    _ctl = ctl;
}
-(void)panAction:(UIPanGestureRecognizer*)pan
{
    UIWindow* parent = [UIApplication sharedApplication].keyWindow;
    if (pan.state==UIGestureRecognizerStateBegan) {
        self.startLoc = [pan locationInView:parent];
        self.startV1 = self.conV1.frame.origin.x;
        self.startV2 = self.conV2.frame.origin.x;
        self.startV3 = self.conV3.frame.origin.x;
        
    }
    else if(pan.state == UIGestureRecognizerStateChanged)
    {
        
        
        
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        
        CGPoint curLoc = [pan locationInView:parent];
        CGFloat offset = curLoc.x-self.startLoc.x;
        CGFloat stateTag = 40;
        if (offset>stateTag) {
            SHSevenDayView* left = [self getLeftView];
            SHSevenDayView* mid = [self getMidView];
            SHSevenDayView* right = [self getRightView];
            CGSize size = self.frame.size;
            [UIView animateWithDuration:0.5 animations:^{
                left.frame = CGRectMake(0, 0, size.width, size.height);
                mid.frame = CGRectMake(size.width, 0, size.width, size.height);
            }];
            right.frame = CGRectMake(-size.width, 0, size.width, size.height);
            
            
            NSDate* start = [left getStartDate];
            [right setEndDate:[start dateByAddingDays:-1]];
            
        }
        else if(offset<-stateTag)
        {
            SHSevenDayView* left = [self getLeftView];
            SHSevenDayView* mid = [self getMidView];
            SHSevenDayView* right = [self getRightView];
            CGSize size = self.frame.size;
            [UIView animateWithDuration:0.5 animations:^{
                right.frame = CGRectMake(0, 0, size.width, size.height);
                mid.frame = CGRectMake(-size.width, 0, size.width, size.height);
            }];
            
            left.frame = CGRectMake(size.width, 0, size.width, size.height);
            
            
            NSDate* start = [right getEndDate];
            [left setStartDate:[start dateByAddingDays:1]];
        }
        [self resetMidSelectUI];
        if (fabs(curLoc.x-self.startLoc.x)<stateTag&& curLoc.y-self.startLoc.y>stateTag) {
            [self showBigCalendar:self.calendarY];
        }
    }
}
-(void)resetMidSelectUI
{
    SHSevenDayView* mid = [self getMidView];
    if (self.curDate.timeIntervalSince1970<[mid getEndDate].timeIntervalSince1970&&self.curDate.timeIntervalSince1970>[mid getStartDate].timeIntervalSince1970) {
        NSDateComponents*cmps = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday|NSCalendarUnitDay|NSCalendarUnitMonth fromDate:self.curDate];
        [mid selectItem:cmps.weekday-1];
    }
}

-(BOOL)isCanMove
{
    SHSevenDayView*midView = [self getMidView];
    NSDate* lastDate = [midView getEndDate];
    
    if ([lastDate timeIntervalSinceNow]>=0||[[NSCalendar currentCalendar] isDateInToday:lastDate]) {
        if (midView.frame.origin.x>0) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
}
-(CGFloat)getSafeOffsetFrom:(CGFloat)offset
{
    SHSevenDayView*midView = [self getMidView];
    NSDate* lastDate = [midView getEndDate];
    
    if ([lastDate timeIntervalSinceNow]>=0||[[NSCalendar currentCalendar] isDateInToday:lastDate]) {
        if (midView.frame.origin.x>0) {
            if (midView.frame.origin.x+offset>=0) {
                return offset;
            }
            else
            {
                return -midView.frame.origin.x;
            }
        }
        else
        {
            return NO;
        }
    }
    return offset;
}

-(UIView*)getLeftViewBy:(UIView*)one with:(UIView*)two
{
    if (one.frame.origin.x<two.frame.origin.x) {
        return one;
    }
    else
    {
        return two;
    }
}
-(UIView*)getRightViewBy:(UIView*)one with:(UIView*)two
{
    if (one.frame.origin.x>two.frame.origin.x) {
        return one;
    }
    else
    {
        return two;
    }
}
-(SHSevenDayView*)getLeftView
{
    SHSevenDayView* one = (SHSevenDayView*)[self getLeftViewBy:self.conV1 with:self.conV2];
    SHSevenDayView* left = (SHSevenDayView*)[self getLeftViewBy:one with:self.conV3];
    return left;
}
-(SHSevenDayView*)getMidView
{
    NSMutableArray* sortV = [[NSMutableArray alloc] init];
    UIView* left = [self getLeftView];
    for (UIView*one in self.allV) {
        if (left!=one) {
            [sortV addObject:one];
        }
    }
    SHSevenDayView* mid = (SHSevenDayView*)[self getLeftViewBy:[sortV objectAtIndex:0] with:[sortV objectAtIndex:1]];
    return mid;
}
-(SHSevenDayView*)getRightView
{
    NSMutableArray* sortV = [[NSMutableArray alloc] init];
    UIView* left = [self getLeftView];
    for (UIView*one in self.allV) {
        if (left!=one) {
            [sortV addObject:one];
        }
    }
    SHSevenDayView* right = (SHSevenDayView*)[self getRightViewBy:[sortV objectAtIndex:0] with:[sortV objectAtIndex:1]];
    return right;
}


-(void)didSelectSevenDayViewDate:(NSDate*)date inView:(SHSevenDayView*)dayView
{
    [self setSelectedDate:date];
    [self hideView];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didHideBigCalendar)]) {
            [self.delegate didHideBigCalendar];
        }
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didSelectedDate:)]) {
            [self.delegate didSelectedDate:date];
        }
    }
}

#pragma mark 大日历
-(void)hideView
{
    [self.bigCalendar removeFromSuperview];

}

-(void)showBigCalendar:(CGFloat)y
{
//    UIWindow* parent = [UIApplication sharedApplication].keyWindow;

    
    self.bigCalendar.canShowFurture = YES;
    self.bigCalendar.transform = CGAffineTransformIdentity;
    self.bigCalendar.frame = CGRectMake(0, y, self.bigCalendar.frame.size.width, self.bigCalendar.frame.size.height);
    
    [self.bigCalendar setDate:self.curDate];
    self.bigCalendar.backgroundColor = [UIColor whiteColor];
    self.bigCalendar.alpha = 1;
    [_ctl.view insertSubview:self.bigCalendar aboveSubview:self.superview];
    
    self.bigCalendar.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didShowBigCalendar:)]) {
            [self.delegate didShowBigCalendar:self.bigCalendar.frame.size];
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.bigCalendar.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.bigCalendar.transform = CGAffineTransformIdentity;
        
    }];
    
}

-(void)didSelectedCalendarViewDate:(NSDate*)selectedDate
{
    [self setSelectedDate:selectedDate];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didHideBigCalendar)]) {
            [self.delegate didHideBigCalendar];
        }
        if ([self.delegate respondsToSelector:@selector(didSelectedDate:)]) {
            [self.delegate didSelectedDate:selectedDate];
        }
    }
}
-(void)didChangeCalendarViewMonth:(NSDate*)curMonth
{
    
}
-(void)panSHCalendarViewAction:(UIPanGestureRecognizer*)pan
{
    UIWindow* parent = [UIApplication sharedApplication].keyWindow;
    if (pan.state==UIGestureRecognizerStateBegan) {
        self.startLoc = [pan locationInView:parent];

        _bigCalendarBeginRect =self.bigCalendar.frame;
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint loc = [pan locationInView:parent];
        if (loc.y<self.startLoc.y&& fabs(loc.x-self.startLoc.x)<30) {
            self.bigCalendar.frame = CGRectMake(_bigCalendarBeginRect.origin.x, _bigCalendarBeginRect.origin.y, _bigCalendarBeginRect.size.width, _bigCalendarBeginRect.size.height);
        }
        
    }
    else
    {
        self.bigCalendar.frame = _bigCalendarBeginRect;
        CGPoint loc = [pan locationInView:parent];
        if (self.startLoc.y-loc.y>40&& fabs(loc.x-self.startLoc.x)<60)
        {
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(didHideBigCalendar)]) {
                    [self.delegate didHideBigCalendar];
                }
            }
            [UIView animateWithDuration:0.5 animations:^{
                self.bigCalendar.transform = CGAffineTransformIdentity;
                self.bigCalendar.transform = CGAffineTransformMakeTranslation(0, -self.bigCalendar.frame.size.height);
            } completion:^(BOOL finished) {
                [self hideView];
            }];
        }
        else
        {
            
            
            BOOL isLeft = NO;
            BOOL isRight = NO;
            if (fabs(loc.y-self.startLoc.y)<40)
            {
                if (loc.x-self.startLoc.x>30) {
                    isLeft = YES;
                    [self.bigCalendar leftClick];
                }
                else if (self.startLoc.x-loc.x>30)
                {
                    isRight = YES;
                    [self.bigCalendar rightClick];
                }
            }
            
            if (isLeft) {
                UIImage *image = [SHMutiCalendarView getImageViewWithView:self.bigCalendar];
                UIImageView* screenshot = [[UIImageView alloc] initWithImage:image];
                screenshot.frame = self.bigCalendar.frame;
                [self.bigCalendar.superview addSubview:screenshot];
                self.bigCalendar.transform = CGAffineTransformTranslate(self.bigCalendar.transform, -self.bigCalendar.frame.size.width, 0);
                [UIView animateWithDuration:0.5 animations:^{
                    self.bigCalendar.transform = CGAffineTransformIdentity;
                    screenshot.transform = CGAffineTransformTranslate(screenshot.transform, screenshot.frame.size.width, 0);
                } completion:^(BOOL finished) {
                    self.bigCalendar.transform = CGAffineTransformIdentity;
                    [screenshot removeFromSuperview];
                }];
            }
            if (isRight) {
                UIImage *image = [SHMutiCalendarView getImageViewWithView:self.bigCalendar];
                UIImageView* screenshot = [[UIImageView alloc] initWithImage:image];
                screenshot.frame = self.bigCalendar.frame;
                [self.bigCalendar.superview addSubview:screenshot];
                self.bigCalendar.transform = CGAffineTransformTranslate(self.bigCalendar.transform, self.bigCalendar.frame.size.width, 0);
                [UIView animateWithDuration:0.5 animations:^{
                    self.bigCalendar.transform = CGAffineTransformIdentity;
                    screenshot.transform = CGAffineTransformTranslate(screenshot.transform, -screenshot.frame.size.width, 0);
                } completion:^(BOOL finished) {
                    self.bigCalendar.transform = CGAffineTransformIdentity;
                    [screenshot removeFromSuperview];
                }];
            }

        }
    }
}
+ (UIImage *)getImageViewWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.frame.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage *)getImageViewWithFrame:(CGRect )frame{
    CGImageRef newImage;
    if (_ctl) {        UIGraphicsBeginImageContext(_ctl.view.frame.size);
        [_ctl.view drawViewHierarchyInRect:_ctl.view.frame afterScreenUpdates:NO];
        UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        newImage = CGImageCreateWithImageInRect(image.CGImage, frame);
    }
    else
    {
        UIWindow* keywindow = [UIApplication sharedApplication].keyWindow;
        UIGraphicsBeginImageContext(keywindow.frame.size);
        [keywindow drawViewHierarchyInRect:keywindow.frame afterScreenUpdates:NO];
        UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        newImage = CGImageCreateWithImageInRect(image.CGImage, frame);
    }
    
    UIImage *image = [[UIImage alloc] initWithCGImage:newImage];
    CGImageRelease(newImage);
    return image;
}
@end
