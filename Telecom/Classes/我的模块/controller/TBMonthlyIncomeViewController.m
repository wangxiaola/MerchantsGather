//
//  TBMonthlyIncomeViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBMonthlyIncomeViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "TBBaseClassViewMode.h"
#import "TBEarningsESRootClass.h"
#import "TBEarningsTableViewCell.h"
@interface TBMonthlyIncomeViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, TBBaseClassViewModeDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *roots;

@property (nonatomic, strong) NSMutableDictionary *parameter;

@property (nonatomic, strong) TBBaseClassViewMode *viewMode;

@end

@implementation TBMonthlyIncomeViewController
- (NSMutableArray *)roots
{
    if (!_roots)
    {
        _roots = [NSMutableArray array];
    }
    return _roots;
}
- (TBBaseClassViewMode *)viewMode
{
    if (!_viewMode)
    {
        _viewMode = [[TBBaseClassViewMode alloc] init];
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
        _tableView.emptyDataSetSource   = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.delegate   = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
}
#pragma mark ---参数配置---
- (void)initData
{
    self.parameter[@"rows"] = @"20";
    self.parameter[@"interfaceId"] = @"276";
    self.parameter[@"type"] = self.type == 0?@"4":@"3";
    self.parameter[@"monkey"] = self.dateString;
    self.parameter[@"id"] = [UserInfo account].userID;
    self.navigationItem.title = [NSString stringWithFormat:@"%@(%@)",self.type == 0?@"一码付收益":@"分销海报收益",self.dateString];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"TBEarningsTableViewCell" bundle:nil] forCellReuseIdentifier:TBEarningsTableViewCellID];
    [self.view addSubview:self.tableView];
    
    TBWeakSelf
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
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
    self.parameter[@"TimeStamp"]  = [ZKUtil timeStamp];
    self.parameter[@"page"] = [NSNumber numberWithInteger:self.page];
    [self.viewMode postDataParameter:self.parameter];
}
#pragma mark ---TBBaseClassViewModeDelegate--
/**
 请求结束
 
 @param array 数据源
 */
- (void)postDataEnd:(NSArray *)array;
{
    NSArray *data = [TBEarningsDetails mj_objectArrayWithKeyValuesArray:array];

    [self.tableView.mj_header endRefreshing];
    if (self.page == 1)
    {
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = NO;
        [self.roots removeAllObjects];
        [self.roots addObjectsFromArray:data];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        [self.roots addObjectsFromArray:data];
    }
    [self.tableView reloadData];
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.roots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBEarningsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBEarningsTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.roots.count > indexPath.row)
    {
        TBEarningsDetails *mode = [self.roots objectAtIndex:indexPath.row];
        [cell updataCellData:mode];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
