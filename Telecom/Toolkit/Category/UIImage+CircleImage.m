//
//  UIImage+CircleImage.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/27.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "UIImage+CircleImage.h"

@implementation UIImage (CircleImage)

- (UIImage *)circleImageForBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 2.开启上下文
    CGFloat imageW = self.size.width + 2 * borderWidth;
    CGFloat imageH = self.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文,这里得到的就是上面刚创建的那个图片上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆。As a side effect when you call this function, Quartz clears the current path.
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [self drawInRect:CGRectMake(borderWidth, borderWidth, self.size.width, self.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;

}

+ (UIImage *)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    UIImage *oldImage = image;
    
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文,这里得到的就是上面刚创建的那个图片上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆。As a side effect when you call this function, Quartz clears the current path.
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)circleImage {
    
    // 开始图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 设置一个范围
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // 根据一个rect创建一个椭圆
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将原照片画到图形上下文
    [self drawInRect:rect];
    
    // 从上下文上获取剪裁后的照片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithCornerRadius:(CGFloat)radius{
    
    CGRect rect = (CGRect){0.f,0.f,self.size};
    
    // void UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);
    //size——同UIGraphicsBeginImageContext,参数size为新创建的位图上下文的大小
    //    opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
    //    scale—–缩放因子
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    
    //根据矩形画带圆角的曲线
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    
    [self drawInRect:rect];
    
    //图片缩放，是非线程安全的
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
