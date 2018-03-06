//
//  UIImage+SCExtension.h
//  SCBasicComponents_Example
//
//  Created by 文堃 杜 on 2018/2/7.
//  Copyright © 2018年 wenkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SCExtension)

#pragma mark - color

/**
 根据颜色生成UIImage对象，生成image大小为(1px * 1px)

 @param color Image的颜色
 @return UIImage
 */
+(UIImage *)imageWithColor:(UIColor *)color;

#pragma mark - gif

/**
 根据名称获取Gif图

 @param name Gif图名称
 @return Gif图
 */
+(UIImage *)animatedGIFNamed:(NSString *)name;

/**
 根据二进制数据获取Gif图

 @param data Gif图的二进制数据
 @return Gif图
 */
+(UIImage *)animatedGIFWithData:(NSData *)data;

/**
 将Gif图self.images数组中的图片按照指定的尺寸缩放，返回一个animatedImage，一次播放的时间是self.duration

 @param size 缩放的尺寸
 @return 缩放后的Gif图
 */
-(UIImage *)animatedImageByScalingAndCroppingToSize:(CGSize)size;

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
-(UIImage *)scaleToSize:(CGSize)size;

/**
 获取裁剪图片

 @param rect 图片需要裁剪的范围
 @return 裁剪出来的图片
 */
-(UIImage*)getSubImage:(CGRect)rect;
/**
 Tint the image in alpha channel with the given color.
 
 @param color  The color.
 */
- (UIImage *)imageByTintColor:(UIColor *)color;
@end
