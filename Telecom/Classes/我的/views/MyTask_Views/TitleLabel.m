
//
//  TitleLabel.m
//  Telecom
//
//  Created by zhangxingdong 张兴栋 on 16/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TitleLabel.h"

@interface TitleLabel () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, assign) CGFloat rightOffset;
@property (nonatomic, assign) CGFloat leftOffset;
@property (nonatomic, weak) UILabel *lastLabel;

@end

#define CELL_HEIGHT 40

@implementation TitleLabel


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView  = [[UIScrollView alloc] init];
         scrollView.delegate = self;
         scrollView.bounces = YES;
         scrollView.scrollEnabled = NO;
         scrollView.pagingEnabled = NO;
         scrollView.userInteractionEnabled = YES;
         scrollView.showsVerticalScrollIndicator = NO;
         scrollView.showsHorizontalScrollIndicator = NO;
         scrollView.backgroundColor = RGB(245, 245, 245);
         scrollView.contentSize = CGSizeMake(self.bounds.size.width + self.bounds.size.width* 2/ 4, CELL_HEIGHT);
        [self addSubview:scrollView];
         _scrollView = scrollView;
    }
    return _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = RGB(245, 245, 245);
        self.clipsToBounds = YES;
        MJWeakSelf
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        [self setUpSubViews];
    }
    return self;
}

// 添加子视图

- (void)setUpSubViews
{
    NSArray *titleArray = @[@"未完成",@"已完成"];
    for (int i = 0; i < 2; i ++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 14)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = NAVIGATION_COLOR;
        titleLabel.text = titleArray[i];
        titleLabel.tag = 100 + i;
        titleLabel.userInteractionEnabled = YES;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        if (i == 1) {
            titleLabel.textColor = [UIColor lightGrayColor];
        } else {
            self.lastLabel = titleLabel;
        }
        
        UIView *lineVw = [[UIView alloc] init];
        lineVw.backgroundColor = NAVIGATION_COLOR;
        [self.scrollView addSubview:lineVw];
        self.lineView = lineVw;
        __block  CGFloat width = -self.bounds.size.width / 4;
        [titleLabel mas_makeConstraints:^ (MASConstraintMaker *make) {
            if (i == 1) {
                  width = self.bounds.size.width / 4;
            }
            make.size.mas_equalTo(CGSizeMake(50, CELL_HEIGHT));
            make.center.mas_equalTo(CGPointMake(width, 0));
        }];
        
        [lineVw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 2));
            make.center.mas_equalTo(CGPointMake(-self.bounds.size.width / 4, 17));
        }];
        
        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClicked:)];
        [titleLabel addGestureRecognizer:tapges];
    }
        _rightOffset = self.scrollView.contentOffset.x;
}

// 点击事件

- (void)titleClicked:(UITapGestureRecognizer *)tap
{
    self.lastLabel.textColor = [UIColor lightGrayColor];
    UILabel *currentLabel = (UILabel *)tap.view;
    currentLabel.textColor = NAVIGATION_COLOR;
    self.lastLabel = currentLabel;
    NSInteger index = tap.view.tag - 100;
    self.block(index);
}

#pragma mark -- 所滑过的第几项与进程


CGFloat offSet = 0;

- (void)scroll_Progress:(CGFloat)progress ForIndex:(NSInteger)index
{
    // 在这里输出 进程 与 第几项
    NSLog(@"\n\n\n\n   progress == %lf and index == %ld",progress,(long)index);
    offSet = (- progress * self.bounds.size.width / 2) + _rightOffset;
    if (progress == 1) {
        _leftOffset = offSet;
    } else if (progress < 0) {
        offSet = (- progress * self.bounds.size.width / 2) + _leftOffset;
    }
    
    [self.scrollView setContentOffset:CGPointMake(offSet, 0) animated:YES];
    
    if (ABS(progress) == 1) {
        self.lastLabel.textColor = [UIColor lightGrayColor];
        UILabel *titleLabel = [self viewWithTag:100 + index];
 
        titleLabel.textColor = NAVIGATION_COLOR;

        self.lastLabel = titleLabel;
    }
}



@end
