//
//  UIImage+CircleImage.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/27.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZKCircleImage(originalImage, borderWidth, borderColor) \
[originalImage circleImageForBorderWidth:borderWidth borderColor:borderColor]

@interface UIImage (CircleImage)

- (UIImage *)circleImageForBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
//将方形图变成带边框的原形图
+ (UIImage *)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
// 圆角
- (UIImage *)circleImage;

- (UIImage *)imageWithCornerRadius:(CGFloat)radius;


@end
