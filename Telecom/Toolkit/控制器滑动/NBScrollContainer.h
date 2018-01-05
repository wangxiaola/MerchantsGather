//
//  NBScrollViewController.h
//  UIPageViewController
//
//  Created by 汤亮 on 16/6/5.
//  Copyright © 2016年 tangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NBScrollContainer;

@protocol NBScrollContainerDataSource <NSObject>
@required
- (NSInteger)numberOfViewControllersInScrollContainView:(NBScrollContainer *)scrollContainer;
- (UIViewController *)scrollContainer:(NBScrollContainer *)scrollContainer viewControllerForIndex:(NSInteger)index;
@end

@protocol NBScrollContainerDelegate <NSObject>
@optional
- (void)scrollContainer:(NBScrollContainer *)scrollContainer didShowViewControllerAtIndex:(NSInteger)index;
- (void)scrollContainer:(NBScrollContainer *)scrollContainer didScroll:(CGPoint)contentOffset;
- (CGSize)scrollContainerItemSize:(NBScrollContainer *)scrollContainer;
- (void)scrollViewWillBeginDragging;
@end

@interface NBScrollContainer : UIView
@property (nonatomic, weak) id<NBScrollContainerDataSource> dataSource;
@property (nonatomic, weak) id<NBScrollContainerDelegate> delegate;
- (void)reloadData;
- (void)showViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated;
@end
