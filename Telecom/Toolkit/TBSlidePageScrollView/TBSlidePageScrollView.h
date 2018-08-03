//
//  TBSlidePageScrollView.h
//  Telecom
//
//  Created by 小腊 on 17/3/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBBasePageTabBar.h"

@class TBSlidePageScrollView;

typedef NS_ENUM(NSUInteger, TBPageTabBarState) {
    TBPageTabBarStateStopOnTop,
    TBPageTabBarStateScrolling,
    TBPageTabBarStateStopOnButtom,
};

@protocol TBSlidePageScrollViewDataSource <NSObject>

@required

// num的页面浏览量
- (NSInteger)numberOfPageViewOnSlidePageScrollView;

// 页面浏览人数需要继承UIScrollView(UITableview继承),和垂直滚动
- (UIScrollView *)slidePageScrollView:(TBSlidePageScrollView *)slidePageScrollView pageVerticalScrollViewForIndex:(NSInteger)index;

@end

@protocol TBSlidePageScrollViewDelegate <NSObject>

@optional

// 垂直滚动任何抵消变化将调用
- (void)slidePageScrollView:(TBSlidePageScrollView *)slidePageScrollView verticalScrollViewDidScroll:(UIScrollView *)pageScrollView;

// pageTabBar垂直滚动和状态
- (void)slidePageScrollView:(TBSlidePageScrollView *)slidePageScrollView pageTabBarScrollOffset:(CGFloat)offset state:(TBPageTabBarState)state;

// pageIndex horizen滚动,当指数变化将调用
- (void)slidePageScrollView:(TBSlidePageScrollView *)slidePageScrollView horizenScrollToPageIndex:(NSInteger)index;

// horizen滚动任何抵消变化将调用
- (void)slidePageScrollView:(TBSlidePageScrollView *)slidePageScrollView horizenScrollViewDidScroll:(UIScrollView *)scrollView;

// horizen滚动开始拖
- (void)slidePageScrollView:(TBSlidePageScrollView *)slidePageScrollView horizenScrollViewWillBeginDragging:(UIScrollView *)scrollView;

// horizen滚动时调用滚动视图嘎然而止
- (void)slidePageScrollView:(TBSlidePageScrollView *)slidePageScrollView horizenScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface TBSlidePageScrollView : UIView

@property (nonatomic, weak)   id<TBSlidePageScrollViewDataSource> dataSource;
@property (nonatomic, weak)   id<TBSlidePageScrollViewDelegate> delegate;

@property (nonatomic, assign) BOOL automaticallyAdjustsScrollViewInsets; // iOS默认没有;(7),它将设置viewController automaticallyAdjustsScrollViewInsets,因为这个属性(是)导致滚动视图布局不正确

@property (nonatomic, assign) BOOL headerViewScrollEnable; // (header区域是否可以上下滑动)
@property (nonatomic, strong) UIView *headerView; //高度默认0
@property (nonatomic, assign) BOOL parallaxHeaderEffect; //(弹性视差效果)

@property (nonatomic, strong) TBBasePageTabBar *pageTabBar;
@property (nonatomic, assign) BOOL pageTabBarIsStopOnTop;  // 默认yes
@property (nonatomic, assign) CGFloat pageTabBarStopOnTopHeight; // 默认值0,bageTabBar站最高高度,如果pageTabBarIsStopOnTop是否定的,这个属性是无效的

@property (nonatomic, strong) UIView *footerView; // 默认无

@property (nonatomic, assign, readonly) NSInteger curPageIndex; // 默认0

// 当滚动到scroll宽度的百分之多少 改变index 
@property (nonatomic, assign) CGFloat changeToNextIndexWhenScrollToWidthOfPercent; 


- (void)reloadData;

- (void)scrollToPageIndex:(NSInteger)index animated:(BOOL)animated;

- (UIScrollView *)pageScrollViewForIndex:(NSInteger)index;

- (NSInteger)indexOfPageScrollView:(UIScrollView *)pageScrollView;

@end
