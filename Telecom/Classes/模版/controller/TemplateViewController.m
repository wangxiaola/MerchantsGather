

//
//  TemplateViewController.m
//  Telecom
//
//  Created by zhangxingdong 张兴栋 on 16/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.
//
#import "HomeCollectionViewCell.h"
#import "HomePageViewController.h"
#import "TemplateViewController.h"
#import "TBHomeDataMode.h"
#import "TBWebViewController.h"
#import "TBTaskSearchView.h"


//  热门模版

@interface TemplateViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layOut;

@property (nonatomic, strong) NSMutableArray<TBHomeModelsRoot*>*modeArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString *key;

@end

@implementation TemplateViewController
{
    CGFloat _CELL_HEIGHT;
}
- (NSMutableArray<TBHomeModelsRoot *> *)modeArray
{

    if (!_modeArray)
    {
        _modeArray = [NSMutableArray array];
    }
    
    return _modeArray;
}
// 基本视图初始化

- (UICollectionView *)collectionView
{
   if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layOut];
       [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell_ID"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layOut
{
   if (!_layOut) {
        _layOut = [[UICollectionViewFlowLayout alloc] init];
        _layOut.itemSize = CGSizeMake((_SCREEN_WIDTH - 30)/2 , _CELL_HEIGHT);
        _layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _layOut.minimumLineSpacing = 20;
        _layOut.minimumInteritemSpacing = 0;
        _layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layOut.headerReferenceSize = CGSizeMake(_SCREEN_WIDTH, 0.000001);
    }
    return _layOut;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _CELL_HEIGHT = 160;
    self.navigationItem.title = @"热门模版";
    // 初始化 顶部 背景视图
    [self initializeView];
}

- (void)initializeView
{

    TBTaskSearchView *searchView = [[TBTaskSearchView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 50) typeSelection:NO];
    [self.view addSubview:searchView];
    [self.view addSubview:self.collectionView];

    self.page = 1;
    self.key = @"";

    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    self.collectionView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingData)];
    
    // 调整布局
    MJWeakSelf
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_bottom);
        make.left.and.right.and.bottom.equalTo(weakSelf.view);
    }];
    

    [searchView setSearchResult:^(NSString *key,NSString *code) {
        
        [weakSelf requestDataSearch:key];
    }];

    [self.collectionView.mj_header beginRefreshing];
    
}

#pragma mark   --- 数据请求 ----
- (void)requestDataSearch:(NSString*)key
{
    [self.modeArray removeAllObjects];
    self.key = key.length == 0?@"":key;
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
    NSMutableDictionary *dic = [NSMutableDictionary params];
    dic[@"key"] = self.key;
    dic[@"interfaceId"] = @"174";
    dic[@"page"] = [NSNumber numberWithInteger:self.page];
    dic[@"rows"] = @"20";
    TBWeakSelf
    [ZKPostHttp post:@"" params:dic cacheType:ZKCacheTypeReturnCacheDataThenLoad success:^(NSDictionary *obj) {
        [weakSelf dataProcessingData:obj];
        
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        hudShowError(@"网络错误");
    }];

}
/**
 *  数据处理
 *
 *  @param responseObject 数据
 */
- (void)dataProcessingData:(NSDictionary*)responseObject
{
    NSDictionary *data = [responseObject valueForKey:@"data"];
    NSDictionary *models = [data valueForKey:@"models"];
    NSInteger total = [[models valueForKey:@"total"] integerValue];
    NSArray *root = [models valueForKey:@"root"];
    hudDismiss();
    
    if (self.page == 1)
    {
        [self.modeArray removeAllObjects];
        [self.collectionView.mj_footer resetNoMoreData];
        self.collectionView.mj_footer.hidden = NO;
        [self.collectionView.mj_header endRefreshing];
    }
    else
    {
        [self.collectionView.mj_footer endRefreshing];
    }
    
    if (root.count == 0)// 无数据
    {
        self.collectionView.mj_footer.hidden = YES;
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        NSString *msg = self.key.length == 0 ?@"暂无数据":@"未查询到相关结果";
        [UIView addMJNotifierWithText:msg dismissAutomatically:YES];
    }
    else if (root.count == total)// 数据加载完
    {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    
    NSArray *mode = [TBHomeModelsRoot mj_objectArrayWithKeyValuesArray:root];
    [self.modeArray addObjectsFromArray:mode];
    [self.collectionView reloadData];
}

#pragma mark  ------  UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modeArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell_ID" forIndexPath:indexPath];

    [cell cellAssignmentData:self.modeArray[indexPath.row] showLabel:YES];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    TBHomeModelsRoot *root = self.modeArray[indexPath.row];
    TBWebViewController *vc = [[TBWebViewController alloc] init];
    [vc loadWebURLSring:root.url];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     [self.view endEditing:YES];
}
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self.view endEditing:YES];
    NSString *key = searchBar.text;
    [self requestDataSearch:key];
    
}

//让 UISearchBar 支持空搜索，当没有输入的时候，search 按钮一样可以点击
- (void)searchBarTextDidBeginEditing:(UISearchBar *) searchBar
{
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
