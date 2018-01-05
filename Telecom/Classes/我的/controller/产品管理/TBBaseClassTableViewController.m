//
//  TBBaseClassTableViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseClassTableViewController.h"
#import "TBBaseClassViewMode.h"
#import "UIScrollView+EmptyDataSet.h"

@interface TBBaseClassTableViewController ()<TBBaseClassViewModeDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TBBaseClassViewMode *viewMode;

@property (nonatomic, assign) NSInteger page;

@end

@implementation TBBaseClassTableViewController
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
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
- (NSMutableArray *)roots
{
    if (!_roots)
    {
        _roots = [NSMutableArray array];
    }
    return _roots;
}
- (NSMutableDictionary *)parameter
{
    if (!_parameter)
    {
        _parameter = [NSMutableDictionary params];
    }
    _parameter[@"TimeStamp"]  = [ZKUtil timeStamp];
    return _parameter;
}

#pragma mark ---初始化视图----
- (void)setUpView
{
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.page = 1;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 10)];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    self.tableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingData)];
    [self.tableView.mj_header beginRefreshing];
    TBWeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}
#pragma mark ---参数配置---
- (void)initData
{
    self.parameter[@"rows"] = @"20";
    
}
#pragma mark   --- 数据请求 ----
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
#pragma mark ---TBBaseClassViewModeDelegate--
/**
 原生数据
 
 @param dictionary 数据
 */
- (void)originalData:(NSDictionary *)dictionary;
{
    
}
/**
 请求结束
 
 @param array 数据源
 */
- (void)postDataEnd:(NSArray *)array;
{
    NSArray *data = [self.modeClass mj_objectArrayWithKeyValuesArray:array];
    
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
    [self  updataTableView];
    [self endDataRequest];
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
- (void)endDataRequest
{
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setUpView];
    
}
- (void)dealloc
{
    self.viewMode.delegate = nil;
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
