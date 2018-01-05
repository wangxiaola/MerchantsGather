//
//  UIImage+Strenching.h
//  slyjg
//
//  Created by 汤亮 on 16/5/17.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Strenching)

/**
 *  以图片中点拉伸
 *
 *  @return 拉伸后图片
 */
- (UIImage *)strechingMiddle;

/**
 *  以某个点拉伸
 *
 *  @param point x和y取值为0~1，分别为图片宽度*x，图片高度*y，得到的点为拉伸点
 *
 *  @return 拉伸后的图片
 */
- (UIImage *)strechingAtPoint:(CGPoint)point;
@end
