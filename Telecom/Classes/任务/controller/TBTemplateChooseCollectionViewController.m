//
//  TBTemplateChooseCollectionViewController.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTemplateChooseCollectionViewController.h"
#import "TBTemplateChooseCollectionViewCell.h"
#import "TBTaskMakeViewController.h"
#import "TBTaskListMode.h"
#import "TBWebViewController.h"
#import "TBHomeDataMode.h"

@interface TBTemplateChooseCollectionViewController ()

@property (nonatomic, strong) NSMutableArray<TBHomeModelsRoot*>*modeArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString *key;

@end

@implementation TBTemplateChooseCollectionViewController

- (NSMutableArray<TBHomeModelsRoot *> *)modeArray
{
    
    if (!_modeArray)
    {
        _modeArray = [NSMutableArray array];
    }
    
    return _modeArray;
}

static NSString * const reuseIdentifier = @"TBTemplateChooseCollectionID";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (instancetype)init
{
    // 创建一个流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell的尺寸
    CGFloat width = (_SCREEN_WIDTH- 30)/2;  //180*width/width
    CGFloat height = width*1.0;
    layout.itemSize = CGSizeMake(width, height);
    // 设置滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 行间距
    layout.minimumLineSpacing = 10;
    // 设置cell之间的间距
    layout.minimumInteritemSpacing = 10;
    //    // 组间距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCollectionView];
    
    
    // Do any additional setup after loading the view.
}
#pragma mark ---- 视图设置 -----
- (void)setCollectionView
{
    self.title = @"模版选择";
    self.clearsSelectionOnViewWillAppear = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TBTemplateChooseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

    
    self.page = 1;
    self.key = @"";

    
    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    self.collectionView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingData)];

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
#pragma mark   --- 数据请求 ----
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
        hudShowInfo(self.key.length == 0 ?@"暂无数据":@"未查询到相关结果");
        [self.collectionView reloadData];
        return;
    }
    else if (root.count == total)// 数据加载完
    {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    
    NSArray *mode = [TBHomeModelsRoot mj_objectArrayWithKeyValuesArray:root];
    [self.modeArray addObjectsFromArray:mode];
    [self.collectionView reloadData];
}


#pragma mark ----- CollectionView datasource ----
//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modeArray.count;;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TBTemplateChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.models = self.modeArray[indexPath.row];
    
    return cell;
}
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"开始制作" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //按钮触发的方法
        [self pushTemplateData:self.modeArray[indexPath.row]];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //按钮触发的方法
        TBHomeModelsRoot *root = self.modeArray[indexPath.row];
        TBWebViewController *vc = [[TBWebViewController alloc] init];
        [vc loadWebURLSring:root.url];
        [self.navigationController pushViewController:vc animated:YES];
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //按钮触发的方法
    }]];
    
    [self presentViewController:alertView animated:YES completion:nil];
    
}
/**
 模板生产
 
 @param root 模板数据
 */
- (void)pushTemplateData:(TBHomeModelsRoot *)root
{
    TBTaskMakeViewController *vc = [[TBTaskMakeViewController alloc] init];
    if (self.list)
    {
        vc.merchantsID = self.list.ID;
        vc.templateType = TBMakingProductionMaking;
    }
    else
    {
        vc.templateType = TBMakingProductionNewAdded;
    }
    vc.modelsID = root.ID;

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
