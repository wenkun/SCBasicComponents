//
//  SCProgressView.m
//  AWFileHash-AWFileHash
//
//  Created by 文堃 杜 on 2020/2/20.
//

#import "SCProgressView.h"
#import "SCDefaultsUI.h"

@implementation SCProgressView

- (instancetype)init
{
    if (self = [super init]) {
        self.progress = 0;
//        self.trackColor = [UIColor whiteColor];
        self.trackColor = [CIColor colorWithRed:1 green:1 blue:1];
        self.backgroundColor = RGBA(51, 51, 51, 1);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.frame.size.height);  //线宽
//    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, self.trackColor.red, self.trackColor.green, self.trackColor.blue, self.trackColor.alpha);  //线的颜色
//    CGContextSetRGBStrokeColor(context, self.trackColor.CIColor.red, self.trackColor.CIColor.green, self.trackColor.CIColor.blue, self.trackColor.CIColor.alpha);  //线的颜色
//    [self.trackColor setStroke];

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.frame.size.height/2);  //起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width*self.progress, self.frame.size.height/2);   //终点坐标
    CGContextStrokePath(context);
//    UIProgressView
    
     // 创建一个贝塞尔曲线
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        // 圆心
//        CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
//        // 圆半径
//        CGFloat radius = MIN(center.x, center.y) - 5;
//        // 开始弧度
//        CGFloat startAngle = - M_PI_2;
//        // 结束弧度
//        CGFloat endAngle = 2 * M_PI * self.progress + startAngle;
//
//        // 化弧
//        [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
//
//        // 设置线宽
//        path.lineWidth = 5;
//        // 设置笔的风格--圆形
//        path.lineCapStyle = kCGLineCapRound;
//        // 设置线的颜色
//        [[UIColor orangeColor] setStroke];
//        // 绘画
//        [path stroke];
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)setTrackColor:(CIColor *)trackColor
{
    _trackColor = trackColor;
    [self setNeedsDisplay];
}

@end
