//
//  UIImage+SCExtension.h
//  SCBasicComponents_Example
//
//  Created by 文堃 杜 on 2018/2/7.
//  Copyright © 2018年 wenkun. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIImage (SCExtension)
#pragma mark - 透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat )alpha;
#pragma mark - color

/**
 根据颜色生成UIImage对象，生成image大小为(1px * 1px)

 @param color Image的颜色
 @return UIImage
 */
+(nullable UIImage *)imageWithColor:(UIColor *)color;

#pragma mark - gif

/**
 根据名称获取Gif图

 @param name Gif图名称
 @return Gif图
 */
+(nullable UIImage *)animatedGIFNamed:(NSString *)name;

/**
 根据二进制数据获取Gif图

 @param data Gif图的二进制数据
 @return Gif图
 */
+(nullable UIImage *)animatedGIFWithData:(NSData *)data;

/**
 将Gif图self.images数组中的图片按照指定的尺寸缩放，返回一个animatedImage，一次播放的时间是self.duration

 @param size 缩放的尺寸
 @return 缩放后的Gif图
 */
-(nullable UIImage *)animatedImageByScalingAndCroppingToSize:(CGSize)size;

#pragma mark - 图片大小处理

/**
 获取图片原始像素大小

 @return 图片原始像素大小
 */
-(CGSize)originalSize;

/**
 计算图片高度和宽度同时不超过superSize的等比缩放或放大的图片的大小。此方法只计算大小，不执行图片的缩放或放大。

 @param superSize 图片缩放或放大所需的最大Size
 @return 计算出等比缩放或放大后的图片大小
 */
-(CGSize)sizeToFitSuperSize:(CGSize)superSize;

/**
 缩放或放大图片

 @param size 缩放或放大图片的目标size
 @return 缩放或放大后的图片
 */
-(nullable UIImage *)scaleToSize:(CGSize)size;

/**
 获取裁剪图片

 @param rect 图片需要裁剪的范围
 @return 裁剪出来的图片
 */
-(nullable UIImage*)getSubImage:(CGRect)rect;
/**
 Tint the image in alpha channel with the given color.
 
 @param color  The color.
 */
- (nullable UIImage *)imageByTintColor:(UIColor *)color;

/**
 Rounds a new image with a given corner size.
 
 @param radius  The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to half
 the width or height.
 */
- (nullable UIImage *)imageByRoundCornerRadius:(CGFloat)radius;

/**
 Rounds a new image with a given corner size.
 
 @param radius       The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to
 half the width or height.
 
 @param borderWidth  The inset border line width. Values larger than half the rectangle's
 width or height are clamped appropriately to half the width
 or height.
 
 @param borderColor  The border stroke color. nil means clear color.
 */
- (nullable UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(nullable UIColor *)borderColor;

/**
 Rounds a new image with a given corner size.
 
 @param radius       The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to
 half the width or height.
 
 @param corners      A bitmask value that identifies the corners that you want
 rounded. You can use this parameter to round only a subset
 of the corners of the rectangle.
 
 @param borderWidth  The inset border line width. Values larger than half the rectangle's
 width or height are clamped appropriately to half the width
 or height.
 
 @param borderColor  The border stroke color. nil means clear color.
 
 @param borderLineJoin The border line join.
 */
- (nullable UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                                       corners:(UIRectCorner)corners
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(nullable UIColor *)borderColor
                                borderLineJoin:(CGLineJoin)borderLineJoin;

@end
NS_ASSUME_NONNULL_END
