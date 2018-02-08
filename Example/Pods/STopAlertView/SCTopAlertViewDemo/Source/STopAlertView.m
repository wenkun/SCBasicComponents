//
//  STopAlertView.m
//  GoodAir
//
//  Created by 文堃 杜 on 16/9/21.
//  Copyright © 2016年 青岛海尔科技有限公司. All rights reserved.
//

#define ST_ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ST_ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ST_iPhoneX (ST_ScreenHeight == 812 ? YES : NO)

#define STTitleFontSize 18.
#define STContentFontSize 18.
#define STDistance_title_content 20.
#define STDistance_top_title 20.
#define STDistance_content_content 4.
#define STDistance_content_button 26.
#define STDistance_button_bottom 23.
#define STDistance_button_H_button 20.
#define STDistance_button_V_button 20.
//#define STButtonHeight 50.
#define STButtonLeading 20.
#define STContentLeading 28.
#define STTitleLeading 36.
#define SFillLabelHeight(height) (height+ceil(STTitleFontSize/5))

#define AnimationDurationTime 0.3

#define STTitleTextColor @"#000000"
#define STContentTextColor @"#b4b4b4"

#import "STopAlertView.h"
#import <RegexKitLite/RegexKitLite.h>


#pragma mark -
#pragma mark - UIColor

@interface UIColor (STHexadecimal)
+ (UIColor *)stColorWithHexString:(NSString *)hexString;
@end

@implementation UIColor (STHexadecimal)
+ (UIColor *)stColorWithHexString:(NSString *)hexString
{
    if (!hexString || hexString.length < 6) {
        return nil;
    }
    
    NSString *hex;
    if ([[hexString substringToIndex:1] isEqualToString:@"#"]) {
        hex = [hexString substringFromIndex:1];
    }
    else {
        hex = hexString;
    }
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setScanLocation:0];
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0 green:((rgbValue & 0xFF00) >> 8) / 255.0 blue:(rgbValue & 0xFF) / 255.0 alpha:1.0];
}
@end

#pragma mark -
#pragma mark - UIImage

@interface UIImage (STColorImage)
+ (UIImage *)stImageWithColor:(UIColor *)color;
@end

@implementation UIImage (STColorImage)
+ (UIImage *)stImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end


#pragma mark -
#pragma mark - STopAlertView

static NSInteger showingNumber = 0;

@interface STopAlertView ()
{
    BOOL _isDisappearing;
    BOOL _hasAddConstraints;
    
    ///button的高度，不同的弹出框样式button高度会不同
    CGFloat _buttonHeight;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) NSArray *buttonTitlesArray;
@property (nonatomic, assign) STopAlertViewStyle style;

@property (nonatomic, strong) NSMutableArray *buttonsArray;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *alertContentView;

@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, copy) STopAlertViewDidClickedButtonBlock clickedButtonBlock;
@property (nonatomic, copy) STopAlertViewDidClickedBackgroundViewBlock clickedBackgroundBlock;

@end

@implementation STopAlertView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithTitle:(NSString *)title contents:(NSArray *)contents buttonTitle:(NSString *)buttonTitle
{
    NSArray *buttonTitleArray = buttonTitle.length > 0 ? @[buttonTitle] : @[];
    return [self initWithTitle:title contents:contents buttonTitlesArray:buttonTitleArray];
}

-(instancetype)initWithTitle:(NSString *)title contents:(NSArray *)contents buttonTitlesArray:(NSArray *)buttonTitlesArray
{
    if (self = [super initWithFrame:CGRectMake(0, 0, ST_ScreenWidth, ST_ScreenHeight)]) {
        self.title = title ?: @"";
        self.contents = contents ?: @[];
        self.buttonTitlesArray = [NSArray arrayWithArray:(buttonTitlesArray ?: @[])];
        [self initWithData];
        [self initViews];
        self.style = STopAlertViewStyleOriginal;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidChangeOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title contents:(NSArray *)contents buttonTitlesArray:(NSArray *)buttonTitlesArray style:(STopAlertViewStyle)style
{
    if (self = [super initWithFrame:CGRectMake(0, 0, ST_ScreenWidth, ST_ScreenHeight)]) {
        self.title = title ?: @"";
        self.contents = contents ?: @[];
        self.buttonTitlesArray = [NSArray arrayWithArray:(buttonTitlesArray ?: @[])];
        self.style = style;
        [self initWithData];
        [self initViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidChangeOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

-(void)initWithData
{
    _isShowing = NO;
    _isDisappearing = NO;
    _lineSpace = STDistance_content_content;
    _minAlertViewHeight = 0;
    _buttonNumberInRow = 1;
    _buttonsArray = [[NSMutableArray alloc] init];
    
    //不同样式初始化不同的数据
    switch (self.style) {
        case STopAlertViewStyle1:
        {
            _buttonHeight = 40;
        }
            break;
            
        default:
        {
            _buttonHeight = 50;
        }
            break;
    }
}

-(void)initViews
{
    self.backgroundColor = [UIColor clearColor];

    _backGroundView = [[UIControl alloc] init];
    _backGroundView.backgroundColor = [[UIColor stColorWithHexString:@"000000"] colorWithAlphaComponent:0.7];
    [_backGroundView addTarget:self action:@selector(touchedBackgrondView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backGroundView];
    
    _alertView = [[UIView alloc] init];
    _alertView.backgroundColor = [UIColor whiteColor];
    if (!ST_iPhoneX) {
        _alertView.layer.borderColor = [UIColor stColorWithHexString:STContentTextColor].CGColor;
        _alertView.layer.borderWidth = 0.5;
        _alertView.layer.opacity = 1;
    }
    [self addSubview:_alertView];
    
    _alertContentView = [[UIView alloc] init];
    _alertContentView.backgroundColor = [UIColor clearColor];
    [self.alertView addSubview:_alertContentView];
    
    _titleLabel = [[YYLabel alloc] init];
    _titleLabel.attributedText = [self getTitleTextAttributeStringWithTitle:self.title];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:STTitleFontSize];
    _titleLabel.numberOfLines = 0;
    [self.alertContentView addSubview:_titleLabel];
    
    _contentLabel = [[YYLabel alloc] init];
    _contentLabel.attributedText = [self getContentTextAttributeStringFromContents:self.contents];
    _contentLabel.font = [UIFont systemFontOfSize:STContentFontSize];
    _contentLabel.numberOfLines = 0;
    [self.alertContentView addSubview:_contentLabel];
    
    for (NSInteger i = 0; i < self.buttonTitlesArray.count; i++) {
        NSString *buttonTitle = self.buttonTitlesArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [self setButtonStyle:button];
        [self.alertContentView addSubview:button];
        [button addTarget:self action:@selector(touchedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsArray addObject:button];
    }
    
    
    //不同样式
    switch (self.style) {
        case STopAlertViewStyle1:
        {
            self.alertView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        }
            break;
            
        default:
            break;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.alertContentView.constraints) {
        [self.alertContentView removeConstraints:self.alertContentView.constraints];
        [self.alertView removeConstraints:self.alertView.constraints];
        [self removeConstraints:self.constraints];
    }
    
    [self setupWithTitle:self.title contents:self.contents buttonTitle:self.buttonTitlesArray];

    if (_hasAddConstraints == NO) {
        _hasAddConstraints = YES;
    }
}

-(void)updateConstraints
{
    [super updateConstraints];
}

#pragma mark - setup view

-(void)setButtonStyle:(UIButton *)button
{
    switch (self.style) {
            
        case STopAlertViewStyle1:
        {
            button.layer.cornerRadius = 8;
            button.clipsToBounds = YES;
            button.layer.borderColor = [UIColor stColorWithHexString:@"BCD2F5"].CGColor;
            button.layer.borderWidth = 1.;
            NSAttributedString *tempAttrStr1 = [[NSAttributedString alloc] initWithString:button.titleLabel.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor stColorWithHexString:@"4990E2"]}];
            NSAttributedString *tempAttrStr2 = [[NSAttributedString alloc] initWithString:button.titleLabel.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor stColorWithHexString:@"BCD2F5"]}];
            [button setAttributedTitle:tempAttrStr1 forState:UIControlStateNormal];
            [button setAttributedTitle:tempAttrStr2 forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage stImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage stImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        }
            break;
            
        case STopAlertViewStyleOriginal:
        default:
        {
            button.layer.cornerRadius = 6;
            button.clipsToBounds = YES;
             [button setBackgroundImage:[UIImage imageNamed:@"con_btn_pre"] forState:UIControlStateNormal];
//            [button setBackgroundImage:[UIImage stImageWithColor:RGB_COLOR(40, 133, 221)] forState:UIControlStateNormal];
//            [button setBackgroundImage:[UIImage stImageWithColor:RGB_COLOR(24, 109, 195)] forState:UIControlStateHighlighted];
        }
            break;
    }
}

///设置 _backGroundView _alertView 和 _alertContentView
-(void)setupWithTitle:(NSString *)title contents:(NSArray *)contents buttonTitle:(NSArray *)buttonTitlesArray
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_backGroundView, _alertView);
    CGFloat top = ST_iPhoneX ? 30 : ([UIApplication sharedApplication].statusBarHidden ? 0 : 20);
    self.contentHeight = [self getContentViewHeightWithTitle:title contents:contents buttonTitlesArray:buttonTitlesArray];
    CGFloat height = (self.minAlertViewHeight > self.contentHeight ? self.minAlertViewHeight : self.contentHeight);
    NSDictionary *metrics = @{@"height":@(height), @"top":@(top)};
    _backGroundView.translatesAutoresizingMaskIntoConstraints = NO;
    _alertView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backGroundView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[_backGroundView]-0-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_alertView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[_alertView(height)]" options:0 metrics:metrics views:views]];
    
    
    views = NSDictionaryOfVariableBindings(_alertContentView);
    if (self.minAlertViewHeight > self.contentHeight) { //如果设置了alert view最小的高度，需要使显示的view居中
        top = (self.minAlertViewHeight - self.contentHeight)/2;
        height = self.contentHeight;
    }
    else {
        top = 0;
    }
    metrics = @{@"height":@(height), @"top":@(top)};
    _alertContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_alertContentView]-0-|" options:0 metrics:nil views:views]];
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[_alertContentView]-top-|" options:0 metrics:metrics views:views]];
    
    
    [self setupContentViewWithTitle:title contents:contents buttonTitlesArray:buttonTitlesArray];
}

///设置 label 和 button
-(void)setupContentViewWithTitle:(NSString *)title contents:(NSArray *)contents buttonTitlesArray:(NSArray *)buttonTitlesArray
{
    NSMutableAttributedString *attString0 = [self getTitleTextAttributeStringWithTitle:title];
    CGSize maxSize0 = CGSizeMake(ST_ScreenWidth-STTitleLeading*2, 800);
    YYTextLayout *textLayout0 = [YYTextLayout layoutWithContainerSize:maxSize0 text:attString0];
    _titleLabel.attributedText = attString0;
    _titleLabel.textLayout = textLayout0;
    
    NSMutableAttributedString *attString = [self getContentTextAttributeStringFromContents:contents];
    CGSize maxSize = CGSizeMake(ST_ScreenWidth-STContentLeading*2, 800);
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:maxSize text:attString];
    _contentLabel.attributedText = attString;
    _contentLabel.textLayout = textLayout;
    
    NSMutableDictionary *views = [[NSMutableDictionary alloc] initWithDictionary:NSDictionaryOfVariableBindings(_titleLabel, _contentLabel)];
    
    NSMutableDictionary *metrics = [[NSMutableDictionary alloc] init];
    [metrics addEntriesFromDictionary:@{@"titleLeading":@(STTitleLeading),
                                        @"titleTop":@(STDistance_top_title),
                                        @"titleHeight":@(title.length > 0 ? SFillLabelHeight(textLayout0.textBoundingSize.height) : 0),
                                        @"contentLeading":@(STContentLeading),
                                        @"contentTop":@(title.length > 0 ? STDistance_title_content : 0),
                                        @"contentHeight":@(attString.string.length > 0 ? SFillLabelHeight(textLayout.textBoundingSize.height) : 0)}];
    
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.alertContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLeading-[_titleLabel]-titleLeading-|" options:0 metrics:metrics views:views]];
    [self.alertContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-titleTop-[_titleLabel(titleHeight)]" options:0 metrics:metrics views:views]];
    
    [self.alertContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-contentLeading-[_contentLabel]-contentLeading-|" options:0 metrics:metrics views:views]];
    [self.alertContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-contentTop-[_contentLabel(contentHeight)]" options:0 metrics:metrics views:views]];
    
    
    //添加Button 
    //修正每一行显示button的数量，防止button数量不足所设置的每行button数量
    _buttonNumberInRow = (buttonTitlesArray.count >= _buttonNumberInRow) ? _buttonNumberInRow : buttonTitlesArray.count;
    
    if (_style == STopAlertViewStyle1) {
        CGFloat buttonLeading = STButtonLeading;
        if (self.buttonsArray.count == 1 || _buttonNumberInRow == 1) {
            buttonLeading = (ST_ScreenWidth - 180.f)/2;
        }
        [metrics addEntriesFromDictionary:@{@"buttonHeight": @(_buttonHeight),
                                            @"buttonLeading1":@(buttonLeading),//距离左边缘的距离
                                            @"buttonLeading2":@(STDistance_button_H_button),//距离左边button的距离
                                            @"buttonTop1":@(attString.string.length > 0 ? STDistance_content_button : 0),
                                            @"buttonTop2":@(STDistance_button_V_button)}];
    }
    else {
        [metrics addEntriesFromDictionary:@{@"buttonHeight": @(_buttonHeight),
                                            @"buttonLeading1":@(STButtonLeading),//距离左边缘的距离
                                            @"buttonLeading2":@(STDistance_button_H_button),//距离左边button的距离
                                            @"buttonTop1":@(attString.string.length > 0 ? STDistance_content_button : 0),
                                            @"buttonTop2":@(STDistance_button_V_button)}];
    }
    
    for (NSInteger i = 0; i < self.buttonsArray.count; i++) {
        UIButton *button = self.buttonsArray[i];
        
        NSString *key = [NSString stringWithFormat:@"button%@",@(i)];
        NSString *leadingKey = [NSString stringWithFormat:@"button%@",@(i-1)];
        NSString *topKey = [NSString stringWithFormat:@"button%@",@(i - _buttonNumberInRow)];
        
        //设置约束
        NSDictionary *dic = NSDictionaryOfVariableBindings(button);
        [views setObject:dic.allValues.firstObject forKey:key];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (i%_buttonNumberInRow == 0) {
            [self.alertContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-buttonLeading1-[%@]", key] options:0 metrics:metrics views:views]];
        }
        else {
            UIButton *leadingButton = self.buttonsArray[i-1];
            
            [self.alertContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[%@]-buttonLeading2-[%@]", leadingKey, key] options:0 metrics:metrics views:views]];
            [self.alertContentView addConstraint:[NSLayoutConstraint constraintWithItem:leadingButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1. constant:0]];
        }
        if (i%_buttonNumberInRow == (_buttonNumberInRow-1) || i == (self.buttonsArray.count -1)) {
            [self.alertContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[%@]-buttonLeading1-|", key] options:0 metrics:metrics views:views]];
        }
        
        if (i/_buttonNumberInRow == 0) {
            [self.alertContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_contentLabel]-buttonTop1-[%@(buttonHeight)]", key] options:0 metrics:metrics views:views]];
        }
        else {
            [self.alertContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[%@]-buttonTop2-[%@(buttonHeight)]", topKey, key] options:0 metrics:metrics views:views]];
        }
    }
}

-(NSMutableAttributedString *)getTitleTextAttributeStringWithTitle:(NSString *)title
{
    NSMutableAttributedString *attString = nil;
    if (self.titleLabel.attributedText) {
        attString = [[NSMutableAttributedString alloc] initWithAttributedString:self.titleLabel.attributedText];
    }
    else {
        attString = [[NSMutableAttributedString alloc] initWithString:title];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.titleLabel.textAlignment;
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];
    attString.yy_font = self.titleLabel.font;
    attString.yy_color = self.titleLabel.textColor;
    attString.yy_lineSpacing = self.lineSpace;
    
    return attString;
}

-(NSMutableAttributedString *)getContentTextAttributeStringFromContents:(NSArray *)contents
{
    NSMutableAttributedString *attString = nil;
    if (self.contentLabel.attributedText) {
        attString = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentLabel.attributedText];
    }
    else {
        NSString *text = @"";
        for (NSString *string in contents) {
            if (text.length == 0) {
                text = string;
            }
            else {
                text = [text stringByAppendingFormat:@"%@",string];
            }
        }
        
        attString = [[NSMutableAttributedString alloc] init];
        NSArray *array = [text componentsMatchedByRegex:@"\\[.*\\]"];
        for (NSString *str in array) {
            if (str.length > 2) {
                NSString *imageName = [str substringWithRange:NSMakeRange(1, str.length-2)];
                UIImage *image = [UIImage imageNamed:imageName];
                NSMutableAttributedString *imageStr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:self.contentLabel.font alignment:YYTextVerticalAlignmentBottom];
                [attString appendAttributedString:imageStr];
                
                text = [text stringByReplacingOccurrencesOfString:str withString:@""];
            }
        }
        
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attString appendAttributedString:textStr];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.contentLabel.textAlignment;
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attString.string.length)];
    attString.yy_font = self.contentLabel.font;
    attString.yy_color = self.contentLabel.textColor;
    attString.yy_lineSpacing = self.lineSpace;

    return attString;
}

-(CGFloat)getContentTextHeightWithContents:(NSAttributedString *)attString
{
    
    CGSize maxSize = CGSizeMake(ST_ScreenWidth-STContentLeading*2, 800);
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:maxSize text:attString];
    
    return textLayout.textBoundingSize.height;
}

-(CGFloat)getContentViewHeightWithTitle:(NSString *)title contents:(NSArray *)contents buttonTitlesArray:(NSArray *)buttonTitlesArray
{
    NSMutableAttributedString *attString0 = [self getTitleTextAttributeStringWithTitle:title];
    CGSize maxSize0 = CGSizeMake(ST_ScreenWidth-STTitleLeading*2, 800);
    YYTextLayout *textLayout0 = [YYTextLayout layoutWithContainerSize:maxSize0 text:attString0];
    
    NSMutableAttributedString *attString = [self getContentTextAttributeStringFromContents:contents];
    CGSize maxSize = CGSizeMake(ST_ScreenWidth-STContentLeading*2, 800);
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:maxSize text:attString];
    
    CGFloat height = STDistance_top_title +
                    (title.length > 0 ? SFillLabelHeight(textLayout0.textBoundingSize.height) : 0) + //label的frame比计算出的多加1
                    (title.length > 0 ? STDistance_title_content : 0) +
                    (attString.string.length > 0 ? SFillLabelHeight(textLayout.textBoundingSize.height) : 0) +  //label的frame比计算出的多加1
                    (attString.string.length > 0 ? STDistance_content_button : 0);
    
    //计算button的行数
    NSInteger numberOfButtonRow;
    if (buttonTitlesArray.count == 0) {
        numberOfButtonRow = 0;
    }
    else {
        numberOfButtonRow = buttonTitlesArray.count/_buttonNumberInRow + (buttonTitlesArray.count%_buttonNumberInRow > 0);
    }
    //计算button占用的高度
    CGFloat button_H = numberOfButtonRow * _buttonHeight +
    (numberOfButtonRow-1 > 0 ? numberOfButtonRow-1 : 0)*STDistance_button_V_button +
    (numberOfButtonRow > 0 ? STDistance_button_bottom : 0);
    
    height += button_H;
    
    return height;
}

#pragma mark - action

-(void)touchedBackgrondView:(id)sender
{
    self.clickedBackgroundBlock ? self.clickedBackgroundBlock(self) : nil;
}

-(void)touchedButton:(UIButton *)button
{
    self.clickedButtonBlock ? self.clickedButtonBlock(self, button) : nil;
}

#pragma mark - interface

-(void)showInController:(UIViewController *)viewController clickedButton:(STopAlertViewDidClickedButtonBlock)clickedButtonBlock clickedBackground:(STopAlertViewDidClickedBackgroundViewBlock)clickedBackgroundBlock
{
    self.clickedButtonBlock = clickedButtonBlock;
    self.clickedBackgroundBlock = clickedBackgroundBlock;
    
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    [viewController.view addSubview:self];
    
    _isShowing = YES;
}

-(void)showWithClickedButton:(STopAlertViewDidClickedButtonBlock)clickedButtonBlock clickedBackground:(STopAlertViewDidClickedBackgroundViewBlock)clickedBackgroundBlock
{
    self.clickedButtonBlock = clickedButtonBlock;
    self.clickedBackgroundBlock = clickedBackgroundBlock;
    
    if (self.superview) {
        [self removeFromSuperview];
        showingNumber --;
    }
    
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    [superView addSubview:self];
    
    _isShowing = YES;
    showingNumber ++;
}

-(void)showWithAnimation:(STopAlertViewAnimation)animation clickedButton:(STopAlertViewDidClickedButtonBlock)clickedButtonBlock clickedBackground:(STopAlertViewDidClickedBackgroundViewBlock)clickedBackgroundBlock
{
    [self showWithClickedButton:clickedButtonBlock clickedBackground:clickedBackgroundBlock];
    [self setContentViewAppearAnimatioan:animation];
}

-(void)disappear
{
    if (_isDisappearing) {
        return;
    }
    
    if (self.superview) {
        [self removeFromSuperview];
        showingNumber --;
    }
    
    _isShowing = NO;
}

-(void)disappearWithAnimatioan:(STopAlertViewAnimation)animation
{
    if (_isDisappearing) {
        return;
    }
    
    if (animation == STopAlertViewAnimationFlipFromTop) {
        _isDisappearing = YES;
        [UIView animateWithDuration:AnimationDurationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alertView.center = CGPointMake(ST_ScreenWidth/2, (self.contentHeight/2+1)*(-1));
            self.backGroundView.alpha = 0;
        } completion:^(BOOL finished) {
            _isDisappearing = NO;
            [self disappear];
        }];
    }
    else {
        [self disappear];
    }
}

-(void)disappearAfterDelay:(NSTimeInterval)delay WithAnimatioan:(STopAlertViewAnimation)animation
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delay + AnimationDurationTime)* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self disappearWithAnimatioan:animation];
    });
}

-(BOOL)hasTopAlertViewShowingInWindow
{
    return (showingNumber > 0);
}

#pragma mark - animation

-(void)setContentViewAppearAnimatioan:(STopAlertViewAnimation)animation
{
    if (animation == STopAlertViewAnimationFlipFromTop) {
        self.contentHeight = [self getContentViewHeightWithTitle:self.title contents:self.contents buttonTitlesArray:self.buttonTitlesArray];
        self.alertView.center = CGPointMake(ST_ScreenWidth/2, (self.contentHeight/2+1)*(-1));
        self.backGroundView.alpha = 0;
        [UIView animateWithDuration:AnimationDurationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGFloat top = [UIApplication sharedApplication].statusBarHidden ? 0 : 20;
            self.alertView.center = CGPointMake(ST_ScreenWidth/2, self.contentHeight/2+top);
            self.backGroundView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Notification

-(void)screenDidChangeOrientationNotification:(NSNotification *)not
{
    [UIView animateWithDuration:AnimationDurationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat top = [UIApplication sharedApplication].statusBarHidden ? 0 : 20;
        self.alertView.center = CGPointMake(ST_ScreenWidth/2, self.contentHeight/2+top);
        self.backGroundView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

@end
