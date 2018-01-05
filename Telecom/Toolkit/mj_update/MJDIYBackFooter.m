//
//  MJDIYBackFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYBackFooter.h"

@interface MJDIYBackFooter()

@property (nonatomic, weak) UIImageView *logo;
@property (nonatomic, weak) UILabel *label;

@end

@implementation MJDIYBackFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@"loading_logo"];
    [self addSubview:logo];
    self.logo = logo;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = NAVIGATION_COLOR;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    self.label = label;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    
    self.logo.mj_w = 15;
    self.logo.mj_h = 16;
    self.logo.mj_x = self.mj_w / 2 - self.logo.mj_w - 28;
    self.logo.mj_y = self.mj_h / 2 - self.logo.mj_h / 2;
    
    self.label.mj_x = self.logo.mj_x + self.logo.mj_w + 6;
    self.label.mj_y = 0;
    self.label.mj_h = self.mj_h;
    self.label.mj_w = self.mj_w - self.logo.mj_x - self.logo.mj_w;

    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"上拉加载更多";
            break;
        case MJRefreshStatePulling:
            self.label.text = @"松开立即刷新";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"加载中...";
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"全部加载完毕";
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
    CGFloat red = 51-pullingPercent*50;
    CGFloat green = 202-pullingPercent*100;
    CGFloat blue = 171-pullingPercent*100;
    self.label.textColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];

}

@end
