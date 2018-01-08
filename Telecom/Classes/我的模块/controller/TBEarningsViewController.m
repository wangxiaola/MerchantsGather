//
//  TBEarningsViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/8/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//


/**
 收益类型
 
 - EarningsTypeYard: 一码付
 - EarningsTypePosters: 分销海报
 */
typedef NS_ENUM(NSInteger, EarningsType) {
    
    EarningsTypeYard = 0,
    EarningsTypePosters
};

#import "TBEarningsViewController.h"
#import "TBContentScrollView.h"
#import "TBEarningsContentTableView.h"
#import "TBEarningsContentView.h"
#import "TBReturnsBalanceView.h"
#import "TBEarningsESRootClass.h"
#import "TBEarningsViewMode.h"
#import "TBMonthlyIncomeViewController.h"
#import "ZKTopTabView.h"

@interface TBEarningsViewController ()<UIScrollViewDelegate, UITableViewDelegate, TBEarningsViewModeDelegate>

@property (nonatomic, strong) TBEarningsViewMode *viewMode;
@property (nonatomic, strong) NSMutableArray <TBEarningsRoot *>*yardArray;
@property (nonatomic, strong) NSMutableArray <TBEarningsRoot *>*postersArray;
@property (nonatomic, assign) CGFloat  yardTradingNumber;//一码总交易
@property (nonatomic, assign) CGFloat  yardEarningsNumber;//一码总收益
@property (nonatomic, assign) CGFloat  postersTradingNumber;//海报总交易
@property (nonatomic, assign) CGFloat  postersEarningsNumber;//海报总收益
@property (nonatomic, assign) NSInteger  yardPage;
@property (nonatomic, assign) NSInteger  postersPage;

@property (nonatomic, strong) NSString *yardDate;
@property (nonatomic, strong) NSString *postersDate;

@property (nonatomic, strong) NSMutableDictionary *parameter;

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) TBEarningsContentView *headerView;
// 收益余额
@property (nonatomic, weak) TBReturnsBalanceView *balanceView;
@property (nonatomic, weak) UIView *tableViewHeadView;
@property (nonatomic, weak) TBContentScrollView *scrollView;
//一码付列表
@property (nonatomic, weak) TBEarningsContentTableView *yardTableView;
//分销海报列表
@property (nonatomic, weak) TBEarningsContentTableView *postersTableView;
@property (nonatomic, weak) ZKTopTabView *pageTitleView;
// 收益类型
@property (nonatomic) EarningsType earningsType;
// 是否请求过海报数据
@property (nonatomic, assign) BOOL isPostPosters;

@end

@implementation TBEarningsViewController
- (NSMutableArray<TBEarningsRoot *> *)postersArray
{
    if (!_postersArray)
    {
        _postersArray = [NSMutableArray array];
    }
    return _postersArray;
}
- (NSMutableArray<TBEarningsRoot *> *)yardArray
{
    if (!_yardArray)
    {
        _yardArray = [NSMutableArray array];
    }
    return _yardArray;
}
- (NSMutableDictionary *)parameter
{
    if (!_parameter)
    {
        _parameter = [NSMutableDictionary params];
    }
    return _parameter;
}

- (TBEarningsViewMode *)viewMode
{
    if (!_viewMode)
    {
        _viewMode = [[TBEarningsViewMode alloc] init];
        _viewMode.delegate = self;
    }
    return _viewMode;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"收益余额";
    self.view.backgroundColor                            = BACKLIST_COLOR;
    self.edgesForExtendedLayout                          = UIRectEdgeNone;
    [self setupContentView];
    [self setupHeaderView];
    [self.yardTableView.mj_header beginRefreshing];
    
}
#pragma mark  ----数据请求----
/**
 *  重新加载数据
 */
- (void)reloadData
{
    switch (self.earningsType) {
        case EarningsTypeYard:
            self.yardArray          = nil;
            self.yardTradingNumber  = 0.0f;
            self.yardEarningsNumber = 0.0f;
            self.yardPage           = 1;
            break;
        case EarningsTypePosters:
            self.postersArray          = nil;
            self.postersTradingNumber  = 0.0f;
            self.postersEarningsNumber = 0.0f;
            self.postersPage           = 1;
            break;
        default:
            break;
    }
    [self requestData];
}
/**
 *  上拉加载数据
 */
- (void)pullLoadingData
{
    if (self.earningsType == EarningsTypeYard)
    {
        self.yardPage++;
    }
    else
    {
        self.postersPage++;
    }
    [self requestData];
}
- (void)requestData
{
    switch (self.earningsType) {
        case EarningsTypeYard:
            self.parameter[@"type"]   = @"4";
            self.parameter[@"monkey"] = self.yardDate;
            self.parameter[@"page"] = [NSNumber numberWithInteger:self.yardPage];
            break;
        case EarningsTypePosters:
            
            self.parameter[@"type"]   = @"3";
            self.parameter[@"monkey"] = self.postersDate;
            self.parameter[@"page"] = [NSNumber numberWithInteger:self.postersPage];
            break;
        default:
            break;
    }
    self.parameter[@"TimeStamp"]  = [ZKUtil timeStamp];
    self.parameter[@"interfaceId"] = @"275";
    self.parameter[@"page"] = [NSNumber numberWithInteger:1];
    self.parameter[@"id"] = [UserInfo account].userID;
//    self.parameter[@"id"] = @"6517";
    self.parameter[@"rows"] = @"10";
    hudShowLoading(@"正在请求数据");
    [self.viewMode postDataParameter:self.parameter];
}
#pragma mark  ----TBEarningsViewModeDelegate----

/**
 请求结束
 
 @param dic 数据源
 */
- (void)postDataEnd:(NSDictionary *)dic;
{
    hudDismiss();
    if (self.earningsType == EarningsTypeYard)
    {
        [self dataProcessingData:self.yardArray :self.yardPage :self.yardTableView :dic];
    }
    else
    {
        self.isPostPosters = YES;
        [self dataProcessingData:self.postersArray :self.postersPage :self.postersTableView :dic];
    }
    [self reloadTableView];
    [self reloadHeaderViewNumberIsRequest:YES];
}
/**
 请求出错了
 
 @param error 错误信息
 */
- (void)postError:(NSString *)error;
{
    [UIView addMJNotifierWithText:@"网络异常!" dismissAutomatically:YES];
    if (self.earningsType == EarningsTypePosters)
    {
        self.isPostPosters = YES;
        [self.postersTableView.mj_header endRefreshing];
        [self.postersTableView.mj_footer endRefreshing];
    }
    else
    {
        [self.yardTableView.mj_header endRefreshing];
        [self.yardTableView.mj_footer endRefreshing];
    }
    hudDismiss();
}
#pragma mark  ----逻辑处理----
// 结果数据处理
- (void)dataProcessingData:(NSMutableArray *)dataArray :(NSInteger)page :(UITableView *)tableView  :(NSDictionary *)dic
{
    CGFloat tradingNumber;
    CGFloat earningsNumber;
    [tableView.mj_header endRefreshing];
    [tableView.mj_footer endRefreshing];
    NSArray *root = [dic valueForKey:@"root"];
    if (root >0)
    {
        NSArray *data = [TBEarningsRoot mj_objectArrayWithKeyValuesArray:root];
        NSArray *numberArray = @[@"0",@"0"];
        NSString *number  = [dic valueForKey:@"number"];
        if ([number isKindOfClass:[NSString class]])
        {
            numberArray = [number componentsSeparatedByString:@"-"];
        }
        
        if (page == 1)
        {
            [tableView.mj_footer resetNoMoreData];
            tableView.mj_footer.hidden = NO;
            [dataArray removeAllObjects];
            [dataArray addObjectsFromArray:data];
        }
        else
        {
            [tableView.mj_footer endRefreshing];
            [dataArray addObjectsFromArray:data];
        }
        
        tradingNumber  =  [numberArray.firstObject floatValue];
        earningsNumber =  [numberArray.lastObject floatValue];
        
        if (self.earningsType == EarningsTypeYard)
        {
            self.yardEarningsNumber = earningsNumber;
            self.yardTradingNumber  = tradingNumber;
            
        }
        else
        {
            self.postersEarningsNumber = earningsNumber;
            self.postersTradingNumber  = tradingNumber;
        }
        
        if (data.count < 10)
        {
            NSString *msg = data.count == 0 ?@"没有数据可显示":@"数据加载完毕";
            [UIView addMJNotifierWithText:msg dismissAutomatically:YES];
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    else
    {
        [UIView addMJNotifierWithText:@"没有数据可显示" dismissAutomatically:YES];
    }
    
}
/**
 更新列表
 */
- (void)reloadTableView
{
    switch (self.earningsType) {
        case EarningsTypeYard:
            [self.yardTableView updataTableViewData:self.yardArray];
            break;
        case EarningsTypePosters:
            [self.postersTableView updataTableViewData:self.postersArray];
            break;
        default:
            break;
    }
}

/**
 更新头部数字显示
 
 @param isRequest 是否是请求数据后
 */
- (void)reloadHeaderViewNumberIsRequest:(BOOL)isRequest;
{
    
    switch (self.earningsType) {
        case EarningsTypeYard:
            
            [self.headerView updataPostersNumber:self.yardEarningsNumber dateString:self.yardDate];
            [self.balanceView updataBalanceNumber:self.yardTradingNumber];
            if (self.yardArray.count == 0 && isRequest == NO)
            {
                [self.yardTableView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            break;
        case EarningsTypePosters:
            if (self.isPostPosters == YES)
            {
                [self.headerView updataPostersNumber:self.postersEarningsNumber dateString:self.postersDate];
                [self.balanceView updataBalanceNumber:self.postersTradingNumber];
            }
            else
            {
                [self.postersTableView.mj_header beginRefreshing];
            }
            if (self.postersArray.count == 0 && isRequest == NO)
            {
                [self.postersTableView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            break;
        default:
            break;
    }
}
#pragma mark  ----视图加载----
/**
 主要内容
 */
- (void)setupContentView
{
    self.isPostPosters = NO;
    self.yardDate = @"";
    self.postersDate = @"";
    CGFloat balanceViewHeight = 80.0f;
    
    TBReturnsBalanceView *balanceView = [[TBReturnsBalanceView alloc] init];
    balanceView.userInteractionEnabled = YES;
    [self.view addSubview:balanceView];
    self.balanceView = balanceView;
    
    
    ZKTopTabView *pageTitleView   = [[ZKTopTabView alloc] initWithTitles:@[@"一码付收益",@"分销海报收益"]];
    pageTitleView.userInteractionEnabled = YES;
    pageTitleView.backgroundColor = [UIColor whiteColor];
    [pageTitleView selectTabBtnAtIndex:0];
    pageTitleView.frame           = CGRectMake(0, balanceViewHeight+10, _SCREEN_WIDTH, 45);
    [self.view addSubview:pageTitleView];
    self.pageTitleView            = pageTitleView;
    // 创建背景框
    UIView *contentView         = [[UIView alloc] init];
    contentView.clipsToBounds   = YES;
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = BACKLIST_COLOR;
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    TBContentScrollView *scrollView           = [[TBContentScrollView alloc] init];
    scrollView.delaysContentTouches           = NO;
    [contentView addSubview:scrollView];
    self.scrollView                           = scrollView;
    scrollView.pagingEnabled                  = YES;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate                       = self;
    scrollView.contentSize                    = CGSizeMake(_SCREEN_WIDTH * 2, 0);
    scrollView.backgroundColor                = BACKLIST_COLOR;
    
    
    UIView *headView                          = [[UIView alloc] init];
    headView.frame                            = CGRectMake(0, 0, 0, TBHeadViewHeight + TBTitleHeight);
    self.tableViewHeadView = headView;
    
    TBEarningsContentTableView *yardTableView = [[TBEarningsContentTableView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 0) style:UITableViewStyleGrouped];
    yardTableView.delegate             = self;
    yardTableView.showsVerticalScrollIndicator = NO;
    yardTableView.backgroundColor      = BACKLIST_COLOR;
    self.yardTableView                 = yardTableView;
    yardTableView.tableHeaderView      = headView;
    yardTableView.tableFooterView      = [[UIView alloc] init];
    [scrollView addSubview:yardTableView];
    
    TBEarningsContentTableView *postersTableView = [[TBEarningsContentTableView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 0) style:UITableViewStyleGrouped];
    postersTableView.delegate             = self;
    postersTableView.showsVerticalScrollIndicator = NO;
    postersTableView.backgroundColor      = BACKLIST_COLOR;
    self.postersTableView                 = postersTableView;
    postersTableView.tableHeaderView      = headView;
    postersTableView.tableFooterView      = [[UIView alloc] init];
    [scrollView addSubview:postersTableView];
    
    yardTableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    postersTableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    yardTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingData)];
    postersTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingData)];
    TBWeakSelf
    [yardTableView setRequestData:^{
        [weakSelf reloadData];
    }];
    [postersTableView setRequestData:^{
        [weakSelf reloadData];
    }];
    
    [pageTitleView setTabBtnClickCallback:^(NSInteger index){
        
        [weakSelf.scrollView setContentOffset:CGPointMake(_SCREEN_WIDTH * index, 0) animated:YES];
        weakSelf.earningsType = index;
        [weakSelf reloadHeaderViewNumberIsRequest:NO];
    }];
    
    [balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(balanceViewHeight);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(pageTitleView.mas_bottom);
    }];
    
    [yardTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView);
        make.width.mas_equalTo(_SCREEN_WIDTH);
        make.top.equalTo(self.pageTitleView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    [postersTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(_SCREEN_WIDTH);
        make.width.mas_equalTo(_SCREEN_WIDTH);
        make.top.bottom.equalTo(yardTableView);
    }];
}

/**
 tableView 的头部视图
 */
- (void)setupHeaderView {
    TBEarningsContentView *headerView = [[TBEarningsContentView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, TBTitleHeight+TBHeadViewHeight)];
    [self.contentView addSubview:headerView];
    self.headerView                   = headerView;
    
    TBWeakSelf
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    [headerView setEarningsSelectionDate:^(NSString *date){
        
        if (weakSelf.earningsType == EarningsTypeYard)
        {
            weakSelf.yardDate = date;
        }
        else
        {
            weakSelf.postersDate = date;
        }
        [weakSelf reloadData];
    }];
    
}
#pragma mark - UIScrollViewDelegate
//滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat contentOffsetX       = scrollView.contentOffset.x;
        NSInteger pageNum            = contentOffsetX / _SCREEN_WIDTH + 0.5;
        [self.pageTitleView selectTabBtnAtIndex:pageNum];
        self.earningsType = pageNum;
        [self reloadHeaderViewNumberIsRequest:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView || !scrollView.window) {
        return;
    }
    CGFloat offsetY      = scrollView.contentOffset.y;
    CGFloat originY      = 0;
    CGFloat otherOffsetY = 0;
    
    if (offsetY <= TBHeadViewHeight)
    {
        originY              = -offsetY;
        if (offsetY < 0) {
            otherOffsetY         = 0;
        } else {
            otherOffsetY         = offsetY;
        }
    } else {
        originY              = -TBHeadViewHeight;
        otherOffsetY         = TBHeadViewHeight;
    }
    self.headerView.frame = CGRectMake(0, originY, _SCREEN_WIDTH, TBHeadViewHeight + TBTitleHeight);
    
    for ( int i = 0; i < self.pageTitleView.titles.count; i++ ) {
        if (i != self.pageTitleView.selectedIndex) {
            UITableView *contentView = self.scrollView.subviews[i];
            CGPoint offset = CGPointMake(0, otherOffsetY);
            if ([contentView isKindOfClass:[UITableView class]]) {
                if (contentView.contentOffset.y < TBHeadViewHeight || offset.y < TBHeadViewHeight) {
                    [contentView setContentOffset:offset animated:NO];
                    self.scrollView.offset = offset;
                }
            }
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100.0f;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    TBEarningsRoot *root = [self viewForHeaderInSection:section];
    return root.count > 10 ?30.0f:0.001f;;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    TBEarningsRoot *root = [self viewForHeaderInSection:section];
    TBEarningsHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TBEarningsHeaderViewID];
    if (root)
    {
        [view updataHeaderViewData:root];
    }
    return view;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
{
    TBEarningsRoot *root = [self viewForHeaderInSection:section];
    if (root.count > 10)
    {
        TBEarningsFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TBEarningsFooterViewID];
        view.section = section;
        TBWeakSelf
        [view setSelectFooterView:^(NSInteger index){
            
            [weakSelf jumpListsIndex:index];
        }];
        return view;
    }
    else
    {
        return [[UIView alloc] init];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 跳转当月列表
 
 @param section 第几个
 */
- (void)jumpListsIndex:(NSInteger)section
{
    TBEarningsRoot *root = [self viewForHeaderInSection:section];
    TBMonthlyIncomeViewController *vc = [[TBMonthlyIncomeViewController alloc] init];
    vc.type = self.earningsType;
    vc.dateString = root.month;
    [self.navigationController pushViewController:vc animated:YES];
}
- (TBEarningsRoot *)viewForHeaderInSection:(NSInteger)section;
{
    TBEarningsRoot *root;
    if (self.earningsType == EarningsTypeYard && section < self.yardArray.count)
    {
        root = [self.yardArray objectAtIndex:section];
    }
    else if (self.earningsType == EarningsTypePosters && section < self.postersArray.count)
    {
        root = [self.postersArray objectAtIndex:section];
    }
    return root;
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
