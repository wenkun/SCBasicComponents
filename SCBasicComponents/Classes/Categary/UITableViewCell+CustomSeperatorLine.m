//
//  UITableViewCell+CustomSeperatorLine.m
//  GoodAir
//
//  Created by 尹啟星 on 2017/8/23.
//  Copyright © 2017年 尹啟星. All rights reserved.
//

#import "UITableViewCell+CustomSeperatorLine.h"
#import <objc/runtime.h>

const HorizontalMargins HorizontalMarginsNull = {.leftMargin = -1, .rightMargin = -1};

bool HorizontalMarginsIsNull(HorizontalMargins margins)
{
    return margins.leftMargin == -1 && margins.rightMargin == -1;
}

#define CustomSeperatorLineInternal_UseAutoLayout 1 // Don't use the auto layout here, because the seperator line must be added to the cell itself, not the content view, however the cell itself doesn't prepared for using layout constraints.

@interface UITableViewCell (CustomSeperatorLineInternal)

@property (nonatomic, strong) UIView *seperatorLine;
@property (nonatomic, strong) UIView *topSeperatorLine;

#if CustomSeperatorLineInternal_UseAutoLayout
@property (nonatomic, strong) NSArray *constraintsForSeperatorLine;
#endif

@end


@implementation UITableViewCell (CustomSeperatorLineInternal)

- (void)setConstraintsForSeperatorLine:(NSArray *)constraintsForSeperatorLine
{
    objc_setAssociatedObject(self, @selector(constraintsForSeperatorLine), constraintsForSeperatorLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)constraintsForSeperatorLine
{
    return objc_getAssociatedObject(self, @selector(constraintsForSeperatorLine));
}

- (void)setSeperatorLine:(UIView *)seperatorLine
{
    objc_setAssociatedObject(self, @selector(seperatorLine), seperatorLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)seperatorLine
{
    return objc_getAssociatedObject(self, @selector(seperatorLine));
}

- (void)setTopSeperatorLine:(UIView *)topSeperatorLine
{
    objc_setAssociatedObject(self, @selector(topSeperatorLine), topSeperatorLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)topSeperatorLine
{
    return objc_getAssociatedObject(self, @selector(topSeperatorLine));
}

@end

#pragma mark -

@implementation UITableViewCell (CustomSeperatorLine)
- (void)removeBottomLine{
    [self removeBottomSeperatorLine];
}
- (void)addTopSeperatorLineIfNeeded
{
    if (!self.topSeperatorLine) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor grayColor];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.topSeperatorLine = line;

        [self addSubview:self.topSeperatorLine];
    }
}

- (void)addSeperatorLineIfNeeded
{
#if CustomSeperatorLineInternal_UseAutoLayout
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor grayColor];
        self.seperatorLine = line;

        [self.contentView addSubview:self.seperatorLine];

#else
    if (!self.seperatorLine) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor grayColor];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.seperatorLine = line;

        [self addSubview:self.seperatorLine];
    }
#endif
}

- (void)removeTopSeperatorLine
{
    if (self.topSeperatorLine) {
        [self.topSeperatorLine removeFromSuperview];
        self.topSeperatorLine = nil;
    }
}

- (void)removeBottomSeperatorLine
{
    if (self.seperatorLine) {
        [self.seperatorLine removeFromSuperview];
        self.seperatorLine = nil;
    }
}

/**
 |-15-line-0-| color:f2f2f2 lineHeight:0.8
 */
- (void)setDefaultBottomSeperatorLine{
    [self setDefaultBottomSeperatorLineWithColor:ColorWithHex(@"f2f2f2")];
}
/**
 |-15-line-0-|  lineHeight:0.8
 */
- (void)setDefaultBottomSeperatorLineWithColor:(UIColor *)color{
    [self setBottomSeperatorLineWithLeft:15
                                   right:0
                                   color:color];
}
- (void)setDefaultBottomSeperatorLineWithLeft:(CGFloat)left right:(CGFloat)right{
    [self setBottomSeperatorLineWithLeft:left
                                   right:right
                                   color:ColorWithHex(@"f2f2f2")];
}
- (void)setBottomSeperatorLineWithLeft:(CGFloat)left
                                 right:(CGFloat)right
                                 color:(UIColor *)color{
    [self setBottomSeperatorLineWithLeft:left
                                   right:right
                                   color:color
                              lineHeight:0.8];
}
- (void)setBottomSeperatorLineWithLeft:(CGFloat)left
                                 right:(CGFloat)right
                                 color:(UIColor *)color
                            lineHeight:(CGFloat)lineHeight{
    [self setBottomSeperatorLineWithMargins:(HorizontalMargins){.leftMargin = left, .rightMargin = right}
                                      color:color
                                 lineHeight:lineHeight];
}
- (void)setBottomSeperatorLineWithMargins:(HorizontalMargins)margins
                                       color:(UIColor *)color
                                   lineHeight:(CGFloat)lineHeight
{
    if (HorizontalMarginsIsNull(margins)) {
        [self removeBottomSeperatorLine];
        return;
    }

    [self addSeperatorLineIfNeeded];

    if (color) {
        self.seperatorLine.backgroundColor = color;
    }

    self.seperatorLine.frame = CGRectMake(margins.leftMargin, self.bounds.size.height - lineHeight, self.bounds.size.width - margins.leftMargin - margins.rightMargin, lineHeight);

#if CustomSeperatorLineInternal_UseAutoLayout
    CGFloat accessroyWidth = 0;
    if (self.accessoryView) {
        accessroyWidth = 16 + CGRectGetWidth(self.accessoryView.frame);
    } else {
        static const CGFloat systemAccessoryWidths[] = {
            [UITableViewCellAccessoryNone] = 0,
            [UITableViewCellAccessoryDisclosureIndicator] = 34,
            [UITableViewCellAccessoryDetailDisclosureButton] = 68,
            [UITableViewCellAccessoryCheckmark] = 40,
            [UITableViewCellAccessoryDetailButton] = 48
        };
        accessroyWidth = systemAccessoryWidths[self.accessoryType];
    }
    UIView *line = self.seperatorLine;
//    CGFloat leftMargin = margins.leftMargin;
//    CGFloat rightMargin = -margins.rightMargin+accessroyWidth;
    
    line.translatesAutoresizingMaskIntoConstraints = NO;
    NSNumber *height = [NSNumber numberWithFloat:lineHeight];
    NSNumber *leftMargin = [NSNumber numberWithFloat:margins.leftMargin];
    NSNumber *rightMargin = [NSNumber numberWithFloat:-(-margins.rightMargin+accessroyWidth)];
    NSDictionary *metrics = NSDictionaryOfVariableBindings(height,leftMargin,rightMargin);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(height)]-0-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(line)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftMargin)-[line]-(rightMargin)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(line)]];
#endif
}

- (void)setTopSeperatorLineWithMargins:(HorizontalMargins)margins
                                    color:(UIColor *)color
                                lineHeight:(CGFloat)lineHeight
{
    if (HorizontalMarginsIsNull(margins)) {
        [self removeTopSeperatorLine];
        return;
    }

    [self addTopSeperatorLineIfNeeded];
    if (color) {
        self.topSeperatorLine.backgroundColor = color;
    }

    self.topSeperatorLine.frame = CGRectMake(margins.leftMargin, 0, self.bounds.size.width - margins.leftMargin - margins.rightMargin, lineHeight);
}

@end
