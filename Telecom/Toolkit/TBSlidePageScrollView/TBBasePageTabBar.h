//
//  TBBasePageTabBar.h
//  Telecom
//
//  Created by 小腊 on 17/3/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//
#import <UIKit/UIKit.h>

@class TBBasePageTabBar;
@protocol TBBasePageTabBarPrivateDelegate <NSObject>

- (void)basePageTabBar:(TBBasePageTabBar *)basePageTabBar clickedPageTabBarAtIndex:(NSInteger)index;

@end

// 基类,完全可定制的pageTabBar继承它
@interface TBBasePageTabBar : UIView

// 当点击pageTabBar指数,改变TYSlidePageScrollView指数
- (void)clickedPageTabBarAtIndex:(NSInteger)index;

// 当TBSlidePageScrollView指数变化,你可以改变你的pageTabBar指数这个方法
- (void)switchToPageIndex:(NSInteger)index;

@end
