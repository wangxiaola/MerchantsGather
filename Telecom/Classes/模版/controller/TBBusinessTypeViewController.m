//
//  TBBusinessTypeViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBusinessTypeTableViewCell.h"
#import "TBBusinessTypeViewController.h"
#import "TBErrorCorrectionViewController.h"
#import "TBTaskListMode.h"
#import "TBTaskMakeViewController.h"
#import "TBTaskSearchView.h"
#import "UIBarButtonItem+Custom.h"
#import "TBBasicDataTool.h"
#import "TBPackagePopView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface TBBusinessTypeViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSMutableArray <TBTaskListRoot*>*rootArray;

@property (nonatomic, assign) BOOL isSearch;//是否正在搜索

@property (nonatomic, strong) NSString *typeName;

@property (nonatomic, assign) NSInteger shopID;

@property (nonatomic, strong) NSMutableArray <TBPackageData *>*packageData;

@property (nonatomic, strong) UserInfo *userInfo;
@end

@implementation TBBusinessTypeViewController
- (NSMutableArray<TBPackageData *> *)packageData
{
    if (!_packageData)
    {
        _packageData = [NSMutableArray array];
    }
    return _packageData;
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
- (NSMutableArray<TBTaskListRoot *> *)rootArray
{
    if (!_rootArray)
    {
        _rootArray = [NSMutableArray array];
    }
    
    return _rootArray;
}
#pragma mark ---初始化视图----
// 模板数据加载
- (void)initData
{
    TBWeakSelf
    [TBBasicDataTool initPackageData:^(NSArray<TBPackageData *> *array)
     {
         [weakSelf.packageData removeAllObjects];
         [weakSelf.packageData addObjectsFromArray:array];
         // 如果是服务场所 加入免费模板
         if (weakSelf.businessType == BusinessTypeNone)
         {
             TBPackageData *data = [[TBPackageData alloc] init];
             data.ID = 5;
             data.title = PACKAGE_0;
             data.price = @"0";
             [weakSelf.packageData insertObject:data atIndex:weakSelf.packageData.count-1];
         }
     }];
}
- (void)initView
{
    CGFloat bottomFlot = 0;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (_SCREEN_HEIGHT == 812) {
        bottomFlot = 34;
    }
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"TBBusinessTypeTableViewCell" bundle:nil] forCellReuseIdentifier:TBBusinessTypeTableViewCellID];
    [self.view addSubview:self.tableView];
    
    TBTaskSearchView *searchView = [[TBTaskSearchView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 50) typeSelection:NO];
    [self.view addSubview:searchView];
    
    
    UIButton *newAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newAddButton setTitle:@"新 增" forState:UIControlStateNormal];
    [newAddButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newAddButton setBackgroundColor:NAVIGATION_COLOR];
    newAddButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:0.2];
    [newAddButton addTarget:self action:@selector(newAddClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newAddButton];
    TBWeakSelf
    [newAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-bottomFlot);
        make.height.equalTo(@50);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(@50);
        make.bottom.equalTo(newAddButton.mas_top);
    }];
    
    [searchView setSearchResult:^(NSString *key,NSString *code) {
        
        [weakSelf requestDataSearch:key];
    }];
    
    self.page = 1;
    self.key = @"";
    
    self.userInfo = [UserInfo account];
    
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    self.tableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingData)];
    
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)setBusinessType:(BusinessType)businessType
{
    _businessType = businessType;
    
    NSDictionary *dic = [[TBBasicDataTool businessType] objectAtIndex:_businessType];
    
    self.title = [dic valueForKey:@"name"];
    self.typeName = [dic valueForKey:@"type"];
    self.shopID = [[dic valueForKey:@"ID"] integerValue];
}
#pragma mark   --- 数据请求 ----
- (void)requestDataSearch:(NSString*)key
{
    self.key = key.length == 0?@"":key;
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
    [self.rootArray removeAllObjects];
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
    NSMutableDictionary *dic = [NSMutableDictionary params];
    dic[@"key"] = self.key;
    dic[@"interfaceId"] = @"176";
    dic[@"page"] = [NSNumber numberWithInteger:self.page];
    dic[@"rows"] = @"20";
    dic[@"id"] = [UserInfo account].userID;
    dic[@"state"] = @"0";
    dic[@"code"] = @"";
    dic[@"type"] = self.typeName;
    TBWeakSelf
    [ZKPostHttp post:@"" params:dic cacheType:ZKCacheTypeReturnCacheDataThenLoad success:^(NSDictionary *obj)
     {
         [weakSelf dataProcessingData:[TBTaskListMode mj_objectWithKeyValues:obj]];
         weakSelf.isSearch = NO;
     } failure:^(NSError *error)
     {
         hudDismiss();
         weakSelf.isSearch = NO;
         [weakSelf.tableView.mj_header endRefreshing];
         [weakSelf.tableView.mj_footer endRefreshing];
     }];
}

/**
 *  数据处理
 *
 *  @param responseObject 数据
 */
- (void)dataProcessingData:(TBTaskListMode*)responseObject
{
    hudDismiss();
    if (self.page == 1)
    {
        [self.rootArray removeAllObjects];
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = NO;
        [self.tableView.mj_header endRefreshing];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    if (responseObject.data.shops.root.count == 0)// 无数据
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
        NSString *msg = self.isSearch == NO ?@"暂无数据":@"未查询到相关结果";
        [UIView addMJNotifierWithText:msg dismissAutomatically:YES];
    }
    else if (responseObject.data.shops.root.count == responseObject.data.shops.total)// 数据加载完
    {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    [self.rootArray addObjectsFromArray:responseObject.data.shops.root];
    
    [self.tableView reloadData];
    
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.rootArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBBusinessTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBBusinessTypeTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.controller = self;
    [cell updateMode:self.rootArray[indexPath.section]];
    TBWeakSelf
    [cell setTableViewCellClick:^(NSInteger row, TBTaskListRoot *root) {
        
        [weakSelf tableViewCellIndex:row data:root];
    }];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
    
    text = @"暂无采集任务。点击加载";
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

#pragma mark --click --
- (void)newAddClick
{
    [self taskToMake:nil];
}
// 任务制作
- (void)taskToMake:(TBTaskListRoot *)root
{
    [UIView dismissMJNotifier];
    // 句容 点击新增都直接进入编辑界面
    if ([self.userInfo.code isEqualToString:JR_CODE])
    {
        TBPackageData *data = [[TBPackageData alloc] init];
        
        if (self.businessType == BusinessTypeNone)
        {
            data.ID = 5;
            data.title = PACKAGE_0;
            data.price = @"0";
        }
        else
        {
            data.ID = 1;
            data.title = PACKAGE_29;
            data.price = @"29";
        }
        [self pushTemplateData:data template:root];
    }
    else
    {
        if (self.packageData.count == 0)
        {
            hudShowInfo(@"数据正在加载中...");
            [self initData];
        }
        else
        {
            TBWeakSelf
            TBPackagePopView *popView = [[TBPackagePopView alloc] init];
            [popView showPackageData:self.packageData selectData:^(TBPackageData *mode)
             {
                 [weakSelf pushTemplateData:mode template:root];
             }];
        }
        
    }
}

/**
 cell 按钮点击
 
 @param row 0 制作  1 纠错
 */
- (void)tableViewCellIndex:(NSInteger )row data:(TBTaskListRoot *)root
{
    if (row == 0)
    {
        [self taskToMake:root];
    }
    else if (self.businessType != BusinessTypeNone)
    {
        TBErrorCorrectionViewController *errorCorrection = [[TBErrorCorrectionViewController alloc] init];
        errorCorrection.errorData = root;
        TBWeakSelf
        [errorCorrection setUpdata:^{
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
        [self.navigationController pushViewController:errorCorrection animated:YES];
    }
    
}

/**
 模板生产
 
 @param root 模板数据
 */
- (void)pushTemplateData:(TBPackageData *)data template:(TBTaskListRoot *)root
{
    TBTaskMakeViewController *vc = [[TBTaskMakeViewController alloc] init];
    if (root)
    {
        vc.merchantsID = root.ID;
        vc.templateType = TBMakingProductionMaking;
    }
    else
    {
        vc.templateType = TBMakingProductionNewAdded;
    }
    
    vc.modelsID = data.ID;
    vc.typeID = self.shopID;
    vc.type = self.typeName;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
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
