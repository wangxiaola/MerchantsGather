//
//  TBMyTaskViewController.m
//  Telecom
//
//  Created by 小腊 on 17/3/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//


#import "TBMyTaskViewController.h"
#import "TBEarningsViewController.h"
#import "TBStrategyViewController.h"
#import "FeedbackController.h"
#import "TBVerifyViewController.h"
#import "ZKNavigationController.h"
#import "TBHeaderJellyView.h"
#import "JPVideoPlayerCache.h"
#import "TBMyBannerView.h"
#import "TBMoreReminderView.h"
#import "ClearCacheTool.h"
#import <JPUSHService.h>

@interface TBMyTaskViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) TBMyBannerView *bannerImageView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *lefInfoData;
@property (assign, nonatomic) CGFloat imageHeight;
@property (strong, nonatomic) TBHeaderJellyView *headerView;
@property (strong, nonatomic) UILabel *footerVersionLabel;
@property (strong, nonatomic) UserInfo *userInfo;
@end

@implementation TBMyTaskViewController


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableView;
}
#pragma mark  ----数据加载----
- (void)initData
{
    self.userInfo = [UserInfo account];
    
    if ([_userInfo.code isEqualToString:JR_CODE]) {
        _lefInfoData = [NSArray arrayWithObjects:
                        @[@{@"name":@"新手攻略",@"image":@"xs-icon"},
                          @{@"name":@"意见反馈",@"image":@"yj-icon"},
                          @{@"name":@"清理缓存",@"image":@"ql-icon"},],
                        @[@{@"name":@"设置密码",@"image":@"mim-icon"},
                          @{@"name":@"退出账号",@"image":@"tch-icon"},],nil];
    }
    else
    {
        _lefInfoData = [NSArray arrayWithObjects:
                        @[@{@"name":@"收益余额",@"image":@"sy-icon"},
                          @{@"name":@"新手攻略",@"image":@"xs-icon"},
                          @{@"name":@"意见反馈",@"image":@"yj-icon"},
                          @{@"name":@"清理缓存",@"image":@"ql-icon"},],
                        @[@{@"name":@"设置密码",@"image":@"mim-icon"},
                          @{@"name":@"退出账号",@"image":@"tch-icon"},],nil];
    }
}
#pragma mark  ----界面布局----
- (void)initBannerView
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    CGFloat cellWidth = 960;
    CGFloat cellHeight = 586;
    self.imageHeight = _SCREEN_WIDTH*cellHeight/cellWidth;
    
    [self.view addSubview:self.tableView];
    
    self.headerView = [[TBHeaderJellyView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, self.imageHeight)];
    [self.view addSubview:self.headerView];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH , self.imageHeight+20)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    self.bannerImageView = [[TBMyBannerView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, self.imageHeight)];
    self.bannerImageView.contenController = self;
    [self.view addSubview:self.bannerImageView];
    self.headerView.backgroundColor = [UIColor clearColor];
    // 手势
    
    self.footerVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 50)];
    self.footerVersionLabel.backgroundColor = [UIColor clearColor];
    self.footerVersionLabel.textColor = [UIColor grayColor];
    self.footerVersionLabel.font = [UIFont systemFontOfSize:13];
    self.footerVersionLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = self.footerVersionLabel;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bannerPanAction:)];
    self.headerView.userInteractionEnabled = YES;
    self.bannerImageView.userInteractionEnabled = YES;
    [self.bannerImageView addGestureRecognizer:pan];
    
    TBWeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(weakSelf.headerView);
        make.bottom.equalTo(weakSelf.headerView.mas_bottom).offset(0);
    }];
    
    [self.tableView reloadData];
    
    
}
- (void)setTableviewStyle
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}
- (void)currentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    self.footerVersionLabel.text = [NSString stringWithFormat:@"当前版本：v%@.%@",app_build,app_Version];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.lefInfoData[section];
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    NSArray *array = self.lefInfoData[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[dic valueForKey:@"image"]];
    cell.textLabel.text = [dic valueForKey:@"name"];
    cell.detailTextLabel.text = @"";
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:3 inSection:0]]) {
        // 缓存大小
        CGFloat size = [ClearCacheTool obtainCacheSize];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",size];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self jumpViewControllerIndexPath:indexPath];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0)
    {
        self.headerView.frame = CGRectMake(0,0, _SCREEN_WIDTH , self.imageHeight - offsetY);
    }
    else
    {
        self.headerView.frame = CGRectMake(0,-offsetY, _SCREEN_WIDTH , self.imageHeight);
    }
}
#pragma mark ---bannerPanAction---
- (void)bannerPanAction:(UIPanGestureRecognizer *)pan
{
    [self.headerView handlePanAction:pan];
    // 禁止动画的时候滑动表格
    self.tableView.scrollEnabled = self.headerView.isAnimating;
}
#pragma mark  ----跳转页面----
- (void)jumpViewControllerIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataArray = [_lefInfoData objectAtIndex:indexPath.section];
    NSDictionary *dic  = [dataArray objectAtIndex:indexPath.row];
    NSString *key      = [dic valueForKey:@"name"];
    
    if ([key isEqualToString:@"收益余额"])
    {
        TBEarningsViewController *vc = [[TBEarningsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([key isEqualToString:@"新手攻略"])
    {
        TBStrategyViewController *strategyView = [[TBStrategyViewController alloc] init];
        [self.navigationController pushViewController:strategyView animated:YES];
    }
    else if ([key isEqualToString:@"意见反馈"])
    {
        FeedbackController *backController = [FeedbackController new];
        [self.navigationController pushViewController:backController animated:YES];
    }
    else if ([key isEqualToString:@"清理缓存"])
    {
        [ClearCacheTool clearActionSuccessful:^{
            [UIView addMJNotifierWithText:@"清理完毕" dismissAutomatically:YES];
            [self updateClearSize];
        }];
    }
    else if ([key isEqualToString:@"设置密码"])
    {
        TBVerifyViewController *passViewC = [[TBVerifyViewController alloc] init];
        [self.navigationController pushViewController:passViewC animated:YES];
    }
    else if ([key isEqualToString:@"退出账号"])
    {
        [self logOutClick];
    }
}

/**
 更新缓存大小
 */
- (void)updateClearSize
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (cell) {
        CGFloat size = [ClearCacheTool obtainCacheSize];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",size];
    }
}
#pragma mark --- 退出登录---
- (void)logOutClick
{
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否退出当前账号?"];
    [more showHandler:^{
        
        [self dataCleaning];
    }];
    
}
// 数据清理
- (void)dataCleaning
{
    [ZKUtil saveBoolForKey:VALIDATION valueBool:NO];
    [ZKUtil saveBoolForKey:START_PAGE valueBool:NO];
    #pragma mark  ----注销APP别名----
    NSString *falseStatic = @"00000000000";
    NSSet *set = [[NSSet alloc] initWithObjects:falseStatic, nil];
    [JPUSHService setTags:set alias:falseStatic fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        MMLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
    }];
    [ClearCacheTool clearActionSuccessful:^{

        [self pushMainViewController];
    }];
    
}
- (void)pushMainViewController
{
    hudDismiss();
    dispatch_async(dispatch_get_main_queue(), ^{
        ZKNavigationController *nav = [[ZKNavigationController alloc] initWithRootViewController:[NSClassFromString(@"TBLogInViewController") new]];
        [APPDELEGATE window].rootViewController = nav;
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:self.tabBarController.selectedIndex == 1];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.headerView endAnimation];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    [self.headerView endAnimation];
    [self updateClearSize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setTableviewStyle];
    [self initBannerView];
    [self currentVersion];

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
