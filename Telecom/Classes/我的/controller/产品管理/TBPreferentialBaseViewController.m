//
//  TBPreferentialBaseViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBPreferentialBaseViewController.h"
#import "TBReleaseCardVoucherViewController.h"
#import "TBPublishingGroupViewController.h"
#import "ZKTopTabView.h"
#import "NBScrollContainer.h"
#import "TBPrivilegeManagementViewController.h"
#import "TBGroupManagementViewController.h"
#import "TBManagementTypeMode.h"

@interface TBPreferentialBaseViewController ()<NBScrollContainerDataSource, NBScrollContainerDelegate>

@property (strong, nonatomic) ZKTopTabView *topBar;
@property (strong, nonatomic) NBScrollContainer *container;
@property (strong, nonatomic) UIButton *increaseButton;//增加优惠
@end

@implementation TBPreferentialBaseViewController
- (UIButton *)increaseButton
{
    if (!_increaseButton)
    {
        _increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _increaseButton.backgroundColor = NAVIGATION_COLOR;
        [_increaseButton setTitle:@"  新 增" forState:UIControlStateNormal];
        [_increaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _increaseButton.titleLabel.font = [UIFont systemFontOfSize:19 weight:0.1];
        [_increaseButton addTarget:self action:@selector(increaseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_increaseButton setImage:[UIImage imageNamed:@"newAdd_ preferential"] forState:UIControlStateNormal];
    }
    return _increaseButton;
}
- (ZKTopTabView *)topBar
{
    if (!_topBar)
    {
        _topBar = [[ZKTopTabView alloc] initWithTitles:@[@"全部",@"进行中",@"未开始",@"已结束"]];
        _topBar.backgroundColor = [UIColor whiteColor];
    }
    return _topBar;
}
- (NBScrollContainer *)container
{
    if (!_container)
    {
        _container = [[NBScrollContainer alloc] init];
        _container.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _container.dataSource = self;
        _container.delegate = self;
    }
    return _container;
}
#pragma mark ---
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialChildVcs];
    [self initialUI];
}
- (void)initialChildVcs
{
    [self addChildViewController:[self setUpOrderViewState:0]];
    [self addChildViewController:[self setUpOrderViewState:1]];
    [self addChildViewController:[self setUpOrderViewState:2]];
    [self addChildViewController:[self setUpOrderViewState:3]];
}
#pragma mark ---  创建订单vc ----
- (TBBaseClassTableViewController*)setUpOrderViewState:(NSInteger)state
{
    if (self.ferentialType == FerentialTypeBulk)
    {
        TBGroupManagementViewController *vc = [[TBGroupManagementViewController alloc] init];
        vc.managementRoot = self.managementRoot;
        vc.state = state;
        return vc;
    }
    else
    {
        TBPrivilegeManagementViewController *vc = [[TBPrivilegeManagementViewController alloc] init];
        vc.managementType = (NSInteger)self.ferentialType;
        vc.managementRoot = self.managementRoot;
        vc.state = state;
        return vc;
    }
}

#pragma mark ----布局---
- (void)initialUI
{
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.container];
    [self.view addSubview:self.increaseButton];
    
    [self.topBar selectTabBtnAtIndex:0];
    
    if (self.ferentialType == FerentialTypeBulk)
    {
        self.navigationItem.title = @"团购秒杀管理";
        [self.increaseButton setTitle:@"  新增团秒杀" forState:UIControlStateNormal];
    }
    else if (self.ferentialType == FerentialTypeVouchers)
    {
        self.navigationItem.title = @"抵用券管理";
        [self.increaseButton setTitle:@"  新增抵用券" forState:UIControlStateNormal];
    }
    else
    {
        self.navigationItem.title = @"打折卡管理";
        [self.increaseButton setTitle:@"  新增打折卡" forState:UIControlStateNormal];
    }
    TBWeakSelf
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.height.equalTo(@46);
    }];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topBar.mas_bottom).offset(1);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.increaseButton.mas_top).offset(0.0f);
    }];
    [self.increaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.height.equalTo(@50);
    }];
    self.topBar.tabBtnClickCallback = ^(NSInteger index) {
        [weakSelf.container showViewControllerAtIndex:index animated:YES];
    };
    [self.topBar selectTabBtnAtIndex:0];
}

#pragma mark --NBScrollContainerDelegate--
- (NSInteger)numberOfViewControllersInScrollContainView:(NBScrollContainer *)scrollContainer
{
    return self.childViewControllers.count;
}

- (UIViewController *)scrollContainer:(NBScrollContainer *)scrollContainer viewControllerForIndex:(NSInteger)index
{
    return self.childViewControllers[index];
}

- (void)scrollContainer:(NBScrollContainer *)scrollContainer didShowViewControllerAtIndex:(NSInteger)index
{
    [self.topBar selectTabBtnAtIndex:index];
}
#pragma mark ---click---
- (void)increaseButtonClick
{
    if (self.ferentialType == FerentialTypeBulk)
    {
        TBPublishingGroupViewController *vc = [[TBPublishingGroupViewController alloc] init];
        vc.shopId = [NSString stringWithFormat:@"%ld",(long)self.managementRoot.ID];
        vc.shopname = self.managementRoot.name;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else
    {
        NSInteger state = self.ferentialType;
        TBReleaseCardVoucherViewController *vc = [[TBReleaseCardVoucherViewController alloc] initReleaseType:state shopid:[NSString stringWithFormat:@"%ld",(long)self.managementRoot.ID]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
