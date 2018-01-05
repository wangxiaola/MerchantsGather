

//
//  TaskViewController.m
//  Telecom
//
//  Created by zhangxingdong 张兴栋 on 16/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TitleLabel.h"
#import "TaskContentView.h"
#import "TaskViewController.h"
#import "MyTaskDetailController.h"


@interface TaskViewController () <TaskContentViewDelegate>

@property (nonatomic, strong) TitleLabel *titleView;

@property (nonatomic, strong) TaskContentView *taskView;

@property (nonatomic, strong) UILabel *downLabel;

@end

@implementation TaskViewController

- (UILabel *)downLabel
{
    if (!_downLabel) {
         _downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 64 - 40, self.view.bounds.size.width, 40)];
         _downLabel.font = [UIFont systemFontOfSize:15];
         _downLabel.backgroundColor = RGB(245, 245, 245);
         _downLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _downLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.title = @"我的任务";
     self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加 屏幕变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    // 设置文字标题
    TitleLabel *titleVw = [[TitleLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    titleVw.backgroundColor = [UIColor brownColor];
    [self.view addSubview:titleVw];
    
    self.titleView = titleVw;
    // 设置可滑动的内容
    __block TaskContentView * taskView = [[TaskContentView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 44 - 100)];
    taskView.delegate = self;
    __weak typeof(taskView) weakTask = taskView;
    // 设置点击过的偏移量
    self.titleView.block = ^(NSInteger index) {
        [weakTask setTheOffsetDistance:CGPointMake(index *(self.view.bounds.size.width), 0) animationd:YES];
    };
    
    MJWeakSelf
    taskView.progressBLK = ^ (CGFloat progress,NSInteger index){
        [weakSelf.titleView scroll_Progress:progress ForIndex:index];
    };
    [self.view addSubview:taskView];
    self.taskView = taskView;
    
    // 添加底部视图
    [self.view addSubview:self.downLabel];
     self.downLabel.attributedText = [self titleAttributedText:nil];
    
    // 设置约束
    
    [titleVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(40);
    }];
    
    [taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(self.view.bounds.size.height - 44 - 100);
    }];
    [self.downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.bounds.size.height - 40 - 64);
        make.height.mas_equalTo(40);
    }];
    
   
}

- (NSMutableAttributedString *)titleAttributedText:(NSString *)labelText
{
    labelText = @"共有 352 个任务";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    
    [attributedString setAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0,labelText.length)];
    [attributedString setAttributes: @{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(0, 3)];
    [attributedString setAttributes: @{NSForegroundColorAttributeName:[UIColor orangeColor]} range:NSMakeRange(3, 3)];
    [attributedString setAttributes: @{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(7,3)];
    
    return attributedString;
}

- (void)changeFrame
{
    // 旋转后移除 重新布局
    [self.taskView removeFromSuperview];
    self.taskView = nil;
    self.taskView = [[TaskContentView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 80)];
    self.taskView.delegate = self;
    
    [self.view addSubview:self.taskView];
    
    [self.titleView removeFromSuperview];
    self.titleView = nil;
    self.titleView = [[TitleLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    [self.view addSubview:self.titleView];
    
    [self.downLabel removeFromSuperview];
    self.downLabel = nil;
    self.downLabel.attributedText = [self titleAttributedText:nil];
    [self.view addSubview:self.downLabel];
    
    MJWeakSelf
    self.taskView.progressBLK = ^ (CGFloat progress,NSInteger index){
        [weakSelf.titleView scroll_Progress:progress ForIndex:index];
    };
    // 设置点击过的偏移量
     __weak typeof(self.taskView) weakTask = self.taskView;
    self.titleView.block = ^(NSInteger index) {
        [weakTask setTheOffsetDistance:CGPointMake(index *(self.view.bounds.size.width), 0) animationd:YES];
    };
    // 设置约束
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(self.view.bounds.size.height - 80);
    }];
    
    [self.downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.bounds.size.height - 40);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark  ----  TaskContentViewDelegate


- (UIViewController *)selectViewController_And_For_indexpath:(NSInteger)index
{
    MyTaskDetailController *controller = [[MyTaskDetailController alloc] init];
    switch (index) {
        case 0: {
            controller.view.backgroundColor = RGB(245, 245, 245);
        }
            break;
        case 1: {
            controller.view.backgroundColor = RGB(245, 245, 245);
        }
            break;
        default:
            break;
    }
    return controller;
}



@end
