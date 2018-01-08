//
//  TBManagementTypeViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBManagementTypeViewController.h"
#import "TBPreferentialBaseViewController.h"
#import "TBManagementTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "TBTaskSearchView.h"
#import "TBManagementTypeMode.h"
#import "TBBasicDataTool.h"
#import "TBManagementViewMode.h"

static NSString * TBManagementTableViewCellID = @"TBManagementTableViewCell";

/**
 团队管理类型
 
 - ManagementTypeCard: 卡券
 - ManagementTypeCardkill: 秒杀
 */
typedef NS_ENUM(NSInteger, ManagementType) {
    
    ManagementTypeCard =0,
    ManagementTypeCardkill
    
};
@interface TBManagementTypeViewController ()<UITableViewDelegate,UITableViewDataSource,TBManagementViewModeDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL isSearch;//是否正在搜索

@property (nonatomic, strong) NSMutableArray *roots;

@property (nonatomic, strong) NSMutableDictionary *parameter;

@property (nonatomic, strong) NSArray <TBPackageData *>*packageData;

@property (nonatomic, strong) TBManagementViewMode *viewMode;


@end

@implementation TBManagementTypeViewController
- (NSMutableArray *)roots
{
    if (!_roots)
    {
        _roots = [NSMutableArray array];
    }
    return _roots;
}
- (TBManagementViewMode *)viewMode
{
    if (!_viewMode)
    {
        _viewMode = [[TBManagementViewMode alloc] init];
        _viewMode.delegate = self;
    }
    return _viewMode;
}
- (NSMutableDictionary *)parameter
{
    if (!_parameter)
    {
        _parameter = [NSMutableDictionary params];
    }
    return _parameter;
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
#pragma mark ---参数配置---
- (void)initData
{
    self.parameter[@"rows"] = @"20";
    self.parameter[@"interfaceId"] = @"247";
    self.parameter[@"state"] = @"1";
    self.parameter[@"type"] = @"0";
    self.parameter[@"id"] = [UserInfo account].userID;
    
    TBWeakSelf
    [TBBasicDataTool initPackageData:^(NSArray<TBPackageData *> *array) {
        weakSelf.packageData = array;
        [weakSelf updataTableView];
    }];
    
}
/**
 主线程刷新
 */
- (void)updataTableView
{
    hudDismiss();
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark ---初始化视图----
- (void)initView
{
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"TBManagementTableViewCell" bundle:nil] forCellReuseIdentifier:TBManagementTableViewCellID];
    [self.view addSubview:self.tableView];
    
    TBTaskSearchView *searchView = [[TBTaskSearchView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 50) typeSelection:YES];
    [self.view addSubview:searchView];
    
    TBWeakSelf
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    
    [searchView setSearchResult:^(NSString *key,NSString *code) {
        
        weakSelf.parameter[@"modelid"] = code;
        weakSelf.parameter[@"key"] = key;
        [weakSelf searchreQuestData];
    }];
    
    self.page = 1;
    
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    self.tableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingData)];
    
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark   --- 数据请求 ----
- (void)searchreQuestData
{
    self.page = 1;
    self.isSearch = YES;
    hudShowLoading(@"正在搜索");
    [self requestData];
}
/**
 *  重新加载数据
 */
- (void)reloadData
{
    self.page = 1;
    [self requestData];
}
/**
 *  上拉加载数据
 */
- (void)pullLoadingData
{
    self.page++;
    [self requestData];
}
- (void)requestData
{
    self.parameter[@"page"] = [NSNumber numberWithInteger:self.page];
    [self.viewMode postDataParameter:self.parameter];
}
#pragma mark ---TBManagementViewModeDelegate--
/**
 请求结束
 
 @param array 数据源
 */
- (void)postDataEnd:(NSArray *)array;
{
    [self.tableView.mj_header endRefreshing];
    if (self.page == 1)
    {
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = NO;
        [self.roots removeAllObjects];
        [self.roots addObjectsFromArray:array];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        [self.roots addObjectsFromArray:array];
    }
    [self  updataTableView];
}
/**
 请求出错了
 
 @param error 错误信息
 */
- (void)postError:(NSString *)error;
{
    hudDismiss();
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
/**
 没有更多数据了
 */
- (void)noMoreData;
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.roots.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBManagementTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.roots.count>0)
    {
        [cell updateMode:self.roots[indexPath.section]];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.roots.count>0)
    {
        [self showAlertData:[self.roots objectAtIndex:indexPath.section]];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

/**
 弹出提示选择框

 @param root 数据
 */
- (void)showAlertData:(TBManagementRoot *)root
{
    if ([root.code isEqualToString:@"service"]) {
        
        [UIView addMJNotifierWithText:@"服务场所没有卡券" dismissAutomatically:YES];
        return;
    }
    BOOL isPrice_99 = root.price == 99;//99的套餐才有团购秒杀管理
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *vouchersAction = [UIAlertAction actionWithTitle:@"抵用券管理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        [self pushPreferentialViewControllerType:FerentialTypeVouchers data:root];
    }];
    
    [alert addAction:vouchersAction];
    UIAlertAction *discountAction = [UIAlertAction actionWithTitle:@"打折卡管理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self pushPreferentialViewControllerType:FerentialTypeDiscount data:root];
    }];
    [alert addAction:discountAction];
    if (isPrice_99 == YES)
    {
        UIAlertAction *bulkAction = [UIAlertAction actionWithTitle:@"团购秒杀管理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self pushPreferentialViewControllerType:FerentialTypeBulk data:root];
        }];
        [alert addAction:bulkAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];

    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

}
// 跳向产品管理页面
- (void)pushPreferentialViewControllerType:(FerentialType)type data:(TBManagementRoot *)root
{
    TBPreferentialBaseViewController *vc = [[TBPreferentialBaseViewController alloc] init];
    vc.managementRoot = root;
    vc.ferentialType = type;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark ---DZNEmptyDataSetSource--

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    text = @"暂无数据可加载，点击加载";
    font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.75];
    textColor = [UIColor grayColor];
    paragraph.lineSpacing = 3.0;
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:NAVIGATION_COLOR range:[attributedString.string rangeOfString:@"点击加载"]];
    
    return attributedString;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 10.0f;
}
// 返回可点击按钮的 image
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"sure_placeholder_error"];
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *imageName = @"sure_placeholder_error";
    
    if (state == UIControlStateNormal) imageName = [imageName stringByAppendingString:@"_normal"];
    if (state == UIControlStateHighlighted) imageName = [imageName stringByAppendingString:@"_highlight"];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
    
    return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}
#pragma mark ---DZNEmptyDataSetDelegate--

// 处理按钮的点击事件
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view;
{
    [self.tableView.mj_header beginRefreshing];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"卡券管理";
    [self initData];
    [self initView];
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
