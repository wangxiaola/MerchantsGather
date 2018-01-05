//
//  TBTimeButton.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/31.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CircleProgressBlock)(void);
@interface TBTimeButton : UIButton

// color
@property (nonatomic,strong)UIColor    *trackColor;

// progress color
@property (nonatomic,strong)UIColor    *progressColor;

// track background color
@property (nonatomic,strong)UIColor    *fillColor;

// progress line width
@property (nonatomic,assign)CGFloat    lineWidth;

// progress duration
@property (nonatomic,assign)CGFloat    animationDuration;

/**
 *  时间到了触发
 *
 *  @param block     block
 *  @param duration  time
 */
- (void)startAnimationDuration:(CGFloat)duration withBlock:(CircleProgressBlock )block;

@end
