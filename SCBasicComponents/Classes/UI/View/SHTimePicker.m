//
//  SHTimePicker.m
//  Robot
//
//  Created by 曹亚男 on 2018/5/16.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHTimePicker.h"
#define PICKER_VIEW_HEIGHT      253
#define PICKER_TITLE_HEIGHT     GET_PIXEL_Y(126)

@interface SHTimePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
///展示数据
@property (nonatomic, strong) NSArray *dataArray;
///选中的数据
@property (nonatomic, strong) NSArray *selectedTimeCombination;
@end

@implementation SHTimePicker

-(instancetype)initWithType:(SHTimePickerType)type
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.type = type;
        self.complementPickerCellLine = YES;
        __weak typeof(self) weakself = self;
        self.doFinishButton = ^(SCAreaChoiseView *areaChoiseView) {
            if (weakself.didSelectedTime) {
                weakself.didSelectedTime(weakself, weakself.selectedTimeCombination);
            }
        };
        self.doCancelButton = ^(SCAreaChoiseView *areaChoiseView) {
            [areaChoiseView dismissWithAnimation:YES];
        };
        self.touchBackground = ^(SCAreaChoiseView *areaChoiseView) {
            [areaChoiseView dismissWithAnimation:YES];
        };
    }
    return self;
}

-(void)setInitialSelectData:(NSArray *)selectData
{
    if (selectData && selectData.count > 0 && selectData.count != self.dataArray.count) {
        return;
    }
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        NSString *selectString = selectData[i];
        NSArray *array = self.dataArray[i];
        for (NSInteger j=0; j<array.count; j++) {
            NSString *string = array[j];
            if ([string isEqualToString:selectString]) {
                [self.pickerView selectRow:j inComponent:i animated:NO];
                break;
            }
        }
    }
}

#pragma mark - property

-(void)setType:(SHTimePickerType)type
{
    _type = type;
    self.dataArray = [self dataWithPickerType:type];
    if (type == SHTimePickerTypeMinuteSecond) {
        [self setPickerViewStyle1];
    }
    else {
        [self setPickerViewStyle2];
    }
}

-(NSArray *)selectedTimeCombination
{
    if (!_selectedTimeCombination) {
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    }
    return _selectedTimeCombination;
}

#pragma mark - data

-(NSArray *)dataWithPickerType:(SHTimePickerType)type
{
    NSArray *dataArray = nil;
    if (type == SHTimePickerTypeMinuteSecond) {
        dataArray = @[[self numberDataFrom:0 to:59],
                      [self numberDataFrom:0 to:59]];
    }
    else if (type == SHTimePickerTypeHourMinute) {
        dataArray = @[[self numberDataFrom:0 to:23],
                      [self numberDataFrom:0 to:59]];
    }
    return dataArray;
}

-(NSArray *)numberDataFrom:(NSInteger)from to:(NSInteger)to
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = from; i <= to ; i++) {
        NSString *string;
        if (i < 10) {
            string = [NSString stringWithFormat:@"0%ld", i];
        }
        else {
            string = [NSString stringWithFormat:@"%ld", i];
        }
        
        [array addObject:string];
    }
    return array;
}

#pragma mark - UI

-(void)setPickerViewStyle1
{
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = [UIFont boldSystemFontOfSize:17];
    label1.textColor = ColorWithHex(@"333333");
    label1.text = @"分";
    [self.pickerView addSubview:label1];
    UILabel *label2 = [[UILabel alloc] init];
    label2.font = [UIFont boldSystemFontOfSize:17];
    label2.textColor = ColorWithHex(@"333333");
    label2.text = @"秒";
    [self.pickerView addSubview:label2];
    
    label1.translatesAutoresizingMaskIntoConstraints = NO;
    label2.translatesAutoresizingMaskIntoConstraints = NO;
    [label1.centerXAnchor constraintEqualToAnchor:self.pickerView.centerXAnchor constant:-8].active = YES;
    [label1.centerYAnchor constraintEqualToAnchor:self.pickerView.centerYAnchor constant:0].active = YES;
    [label2.centerXAnchor constraintEqualToAnchor:label1.centerXAnchor constant:(ScreenWidth-16.)/4.+4].active = YES;
    [label2.centerYAnchor constraintEqualToAnchor:label1.centerYAnchor constant:0].active = YES;
    
    [self setPickerViewSelectedCellLines];
}

-(void)setPickerViewStyle2
{
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = [UIFont boldSystemFontOfSize:17];
    label1.textColor = ColorWithHex(@"333333");
    label1.text = @":";
    [self.pickerView addSubview:label1];
    
    label1.translatesAutoresizingMaskIntoConstraints = NO;
    [label1.centerXAnchor constraintEqualToAnchor:self.pickerView.centerXAnchor constant:4].active = YES;
    [label1.centerYAnchor constraintEqualToAnchor:self.pickerView.centerYAnchor constant:0].active = YES;
    
    [self setPickerViewSelectedCellLines];
}

-(void)setPickerViewSelectedCellLines
{
    if (!self.complementPickerCellLine) {
        return;
    }
    
    if (![self.pickerView viewWithTag:101]) {
        UIView *lineTop = [[UIView alloc] init];
        lineTop.backgroundColor = ColorLine;
        lineTop.tag = 101;
        [self.pickerView addSubview:lineTop];
        
        lineTop.translatesAutoresizingMaskIntoConstraints = NO;
        [lineTop.leftAnchor constraintEqualToAnchor:self.pickerView.leftAnchor].active = YES;
        [lineTop.rightAnchor constraintEqualToAnchor:self.pickerView.rightAnchor].active = YES;
        [lineTop.centerYAnchor constraintEqualToAnchor:self.pickerView.centerYAnchor constant:-23].active = YES;
        [lineTop.heightAnchor constraintEqualToConstant:1].active = YES;
    }
    
    if (![self.pickerView viewWithTag:102]) {
        UIView *lineBottom = [[UIView alloc] init];
        lineBottom.backgroundColor = ColorLine;
        lineBottom.tag = 102;
        [self.pickerView addSubview:lineBottom];
        
        lineBottom.translatesAutoresizingMaskIntoConstraints = NO;
        [lineBottom.leftAnchor constraintEqualToAnchor:self.pickerView.leftAnchor].active = YES;
        [lineBottom.rightAnchor constraintEqualToAnchor:self.pickerView.rightAnchor].active = YES;
        [lineBottom.centerYAnchor constraintEqualToAnchor:self.pickerView.centerYAnchor constant:22].active = YES;
        [lineBottom.heightAnchor constraintEqualToConstant:1].active = YES;
    }
}

#pragma mark picker view

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *array = [self.dataArray objectAtIndex:component];
    return array.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return (ScreenWidth-16.)/4.;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string = [[self.dataArray objectAtIndex:component] objectAtIndex:row];
    return string;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableArray * timeCombination = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    for (NSArray *array in self.dataArray) {
        if (array.count > 0) {
            NSString *string = [array objectAtIndex:[pickerView selectedRowInComponent:i]];
            [timeCombination addObject:string];
        }
        i++;
    }
    self.selectedTimeCombination = [NSArray arrayWithArray:timeCombination];
}

@end
