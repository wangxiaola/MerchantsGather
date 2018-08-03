//
//  TBSlidePageScrollViewController.h
//  Telecom
//
//  Created by 小腊 on 17/3/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBSlidePageScrollView.h"

@protocol TBDisplayPageScrollViewDelegate <NSObject>

// 加载视图
- (UIScrollView *)displayPageScrollView;

@end

@interface TBSlidePageScrollViewController : UIViewController<TBSlidePageScrollViewDelegate,TBSlidePageScrollViewDataSource>

@property (nonatomic, weak, readonly) TBSlidePageScrollView *slidePageScrollView;

// 视图数组
@property (nonatomic, strong) NSArray   *viewControllers;
@end
