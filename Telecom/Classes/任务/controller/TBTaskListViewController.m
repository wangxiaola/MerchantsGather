//
//  TBTaskListViewController.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTaskListViewController.h"
#import "TBTaskListTypeViewController.h"
#import "TBAddMerchantsViewController.h"
#import "TBTaskSearchView.h"
#import "TBTitlePageTabBar.h"
#import "UIButton+ImageTitleStyle.h"
#import "UIBarButtonItem+Custom.h"
#import "AppDelegate.h"
@interface TBTaskListViewController ()

@property (nonatomic, assign) CGFloat navigationHieght;

@end

@implementation TBTaskListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    [(AppDelegate *)APPDELEGATE setIsProcessingNotice:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView dismissMJNotifier];
}
- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    [(AppDelegate *)APPDELEGATE setIsProcessingNotice:NO];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (KIsiPhoneX) {
        self.slidePageScrollView.pageTabBarStopOnTopHeight = 40.0f;
        self.navigationHieght = 84;
    } else {
        self.navigationHieght = 64;
        self.slidePageScrollView.pageTabBarStopOnTopHeight = 20.0f;
    }
    self.slidePageScrollView.pageTabBarStopOnTopHeight = 20.0f;
    
    self.viewControllers = @[[self creatViewControllerPage:0],[self creatViewControllerPage:1],[self creatViewControllerPage:2]];

    [self addHeaderView];
    
    [self addTabPageMenu];
    
    [self.slidePageScrollView reloadData];
}

#pragma mark ---初始化视图----

- (void)addHeaderView
{
    UIView *topNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 20)];
    topNavView.backgroundColor = NAVIGATION_COLOR;
    [self.view addSubview:topNavView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.frame), self.navigationHieght+50)];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, _SCREEN_WIDTH, 44)];
    navView.backgroundColor = NAVIGATION_COLOR;
    [headerView addSubview:navView];
    
    UIBarButtonItem *lefItem = [UIBarButtonItem setRitWithTitel:@"返回" itemWithIcon:@"nav_back" target:self action:@selector(goBack)];
    [navView addSubview:lefItem.customView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"已提交任务";
    titleLabel.font = [UIFont systemFontOfSize:18 weight:0.2];
    titleLabel.textColor = [UIColor whiteColor];
    [navView addSubview:titleLabel];
    
    TBTaskSearchView *searchView = [[TBTaskSearchView alloc] initWithFrame:CGRectMake(0, self.navigationHieght, _SCREEN_WIDTH, 50) typeSelection:YES];
    [headerView addSubview:searchView];
    TBWeakSelf
    // 搜索结果展示
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView.mas_bottom).offset(-50);
        make.left.right.top.equalTo(headerView);
    }];
    
    [searchView setSearchResult:^(NSString *key, NSString*code)
     {
         [weakSelf dataSearch:key search:code];
     }];
    [lefItem.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(headerView.mas_left).offset(20);
        make.bottom.equalTo(navView.mas_bottom).offset(-14);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(navView.mas_bottom).offset(-14);
        make.centerX.equalTo(navView.mas_centerX);
    }];

    self.slidePageScrollView.headerView = headerView;
}

- (void)addTabPageMenu
{
    TBTitlePageTabBar *titlePageTabBar = [[TBTitlePageTabBar alloc]initWithTitleArray:@[@"已通过",@"未通过",@"待审核"]];
    titlePageTabBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.slidePageScrollView.frame), 44);
    titlePageTabBar.edgeInset = UIEdgeInsetsMake(0, 36, 0,36);
    titlePageTabBar.titleSpacing = 8;
    titlePageTabBar.selectedTextColor = NAVIGATION_COLOR;
    titlePageTabBar.horIndicatorColor = NAVIGATION_COLOR;
    titlePageTabBar.backgroundColor = [UIColor whiteColor];
    self.slidePageScrollView.pageTabBar = titlePageTabBar;

}

- (void)slidePageScrollView:(TBSlidePageScrollView *)slidePageScrollView pageTabBarScrollOffset:(CGFloat)offset state:(TBPageTabBarState)state
{
    [self.view endEditing:YES];
}

- (UIViewController *)creatViewControllerPage:(NSInteger)page
{
    
    TBTaskListTypeViewController *vc = [[TBTaskListTypeViewController alloc] initType:page+1];

    return vc;
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --TYDisplayPageScrollViewDelegate--
// pageIndex horizen滚动,当指数变化将调用
- (void)slidePageScrollView:(TBSlidePageScrollView *)slidePageScrollView horizenScrollToPageIndex:(NSInteger)index;
{

}
// horizen滚动时调用滚动视图嘎然而止
- (void)slidePageScrollView:(TBSlidePageScrollView *)slidePageScrollView horizenScrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{


}

#pragma mark  搜索

- (void)dataSearch:(NSString*)key search:(NSString *)code;
{
    TBTaskListTypeViewController *vc_w = [self.viewControllers objectAtIndex:0];
    [vc_w requestDataSearch:key searchCode:code];
    
    TBTaskListTypeViewController *vc_b =[self.viewControllers objectAtIndex:1];
    [vc_b requestDataSearch:key searchCode:code];
    
    TBTaskListTypeViewController *vc_d = [self.viewControllers objectAtIndex:2];
    [vc_d requestDataSearch:key searchCode:code];
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
