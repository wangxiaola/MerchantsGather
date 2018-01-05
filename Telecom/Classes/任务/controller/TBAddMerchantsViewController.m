 //
//  TBAddMerchantsViewController.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/9.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBAddMerchantsViewController.h"
#import "TBTaskSearchView.h"
#import "TBAddNewMerchantsTableViewCell.h"
#import "TBTemplateChooseCollectionViewController.h"
#import "TBAddMerchantsMode.h"

@interface TBAddMerchantsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *seaechBackView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) NSMutableArray <TBAddMerchantsMode *>*dataArray;
@end

@implementation TBAddMerchantsViewController

- (NSMutableArray <TBAddMerchantsMode *>*)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setViewStyle];
}

/**
 设置视图样式
 */
- (void)setViewStyle
{
    self.title = @"新增商家";
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.seaechBackView.backgroundColor = [UIColor whiteColor];
    self.addButton.layer.cornerRadius = 4;
    self.promptLabel.text = @"没有要找的商家?";
    
    TBTaskSearchView *searchView = [[TBTaskSearchView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 50) typeSelection:NO];
    [self.seaechBackView addSubview:searchView];
    // 搜索结果展示
    TBWeakSelf
    [searchView setSearchResult:^(NSString *key, NSString*code) {
        [weakSelf postData:key];
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TBAddNewMerchantsTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.page = 1;
    self.key = @"";
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    self.tableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingData)];
    self.tableView.hidden = YES;
    
}
#pragma mark --- 数据请求 -----
- (void)postData:(NSString*)key
{
    self.key = key;
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
    [self.dataArray removeAllObjects];
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
    if (self.key.length == 0)
    {
        [self.tableView.mj_header endRefreshing];
        if (self.dataArray.count >0)
        {
            hudDismiss();
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            self.tableView.hidden = YES;
        }
        else
        {
            hudShowInfo(@"请输入查询名称");
        }
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary params];
    dic[@"interfaceId"] = @"180";
    dic[@"name"] = self.key;
    dic[@"page"] = [NSNumber numberWithInteger:self.page];
    dic[@"rows"] = @"20";
    
    TBWeakSelf
    [ZKPostHttp post:@"" params:dic cacheType:ZKCacheTypeReturnCacheDataThenLoad success:^(NSDictionary *obj) {
        
        [weakSelf dataProcessingData:obj];
        
    } failure:^(NSError *error)
     {
         hudShowError(@"网络错误");
     }];
}
/**
 *  数据处理
 *
 *  @param responseObject 数据
 */
- (void)dataProcessingData:(NSDictionary *)responseObject
{
    hudDismiss();
    NSString *errcode =[responseObject valueForKey:@"errcode"];
    if (![errcode isEqualToString:@"00000"])
    {
        [self.tableView.mj_header endRefreshing];
        hudShowError([responseObject valueForKey:@"errmsg"]);
        return;
    }
    NSDictionary *data = [responseObject valueForKey:@"data"];
    NSInteger total = [[data valueForKey:@"total"] integerValue];
    NSArray *root = [data valueForKey:@"root"];
    NSArray <TBAddMerchantsMode *>*rootArray = [TBAddMerchantsMode mj_objectArrayWithKeyValuesArray:root];
    
    if (self.page == 1)
    {
        [self.dataArray removeAllObjects];
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = NO;
        [self.tableView.mj_header endRefreshing];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    
    if (rootArray.count == 0)// 无数据
    {
        self.tableView.mj_footer.hidden = YES;
        NSString *msg = self.key.length == 0 ?@"暂无数据":@"未查询到相关结果";
        [UIView addMJNotifierWithText:msg dismissAutomatically:YES];
    }
    else if (rootArray.count == total)// 数据加载完
    {
        NSString *msg = [NSString stringWithFormat:@"查询到%lu条数据",(unsigned long)rootArray.count];
        [UIView addMJNotifierWithText:msg dismissAutomatically:YES];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.dataArray addObjectsFromArray:rootArray];
    self.tableView.hidden = self.dataArray.count == 0 ? YES:NO;
    [self.tableView reloadData];
    
}


#pragma mark --- tableViewDelegate -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBAddNewMerchantsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.mode = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark -- 点击事件 --
- (IBAction)newBusinessesClick:(UIButton *)sender
{
    TBTemplateChooseCollectionViewController *vc = [[TBTemplateChooseCollectionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
