
//
//  HomePageViewController.m
//  Telecom
//
//  Created by zhangxingdong 张兴栋 on 16/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.

static NSString *bannerName = @"banner";
// 间隙
static CGFloat cellClearance = 0.00f;

#import "HomePageViewController.h"
#import "TBBasicDataTool.h"
#import "TBBusinessTypeViewController.h"
#import "TBMainCollectionViewCell.h"
#import "TBStrategyViewController.h"
#import "TBWaitingTaskDataViewController.h"
#import "TBTaskListViewController.h"
#import "TBManagementTypeViewController.h"
#import "TBMakingSaveTool.h"
#import <JPUSHService.h>

#import "TBVideoShootingController.h"
// 首页
@interface HomePageViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
//底层背景图
@property (nonatomic, assign) CGFloat imageHight;
@property (nonatomic, strong) NSArray *backImageNameArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layOut;
@property (nonatomic, strong) UIImageView *strategyBackView;
@property (nonatomic, strong) UIImageView *zoomImageView;
@property (strong, nonatomic) TBMakingSaveTool *saveTool;
// 草稿箱数量
@property (nonatomic, assign) NSInteger completeNumber;
// 待提交数量
@property (nonatomic, assign) NSInteger imperfectNumber;

@end

@implementation HomePageViewController

/* 基本视图初始化 */

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layOut];
        [_collectionView registerClass:[TBMainCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell_ID"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = YES;
        
    }
    return _collectionView;
}

/*设置ColllectionView约束*/

- (UICollectionViewFlowLayout *)layOut
{
    if (!_layOut) {
        _layOut = [[UICollectionViewFlowLayout alloc] init];
        _layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layOut.minimumLineSpacing = cellClearance;
        _layOut.minimumInteritemSpacing = cellClearance;
    }
    return _layOut;
}
- (UIImageView *)strategyBackView
{
    if (!_strategyBackView)
    {
        _strategyBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"strategy_0"]];
        _strategyBackView.frame = CGRectMake(0, 0, _SCREEN_WIDTH, _SCREEN_HEIGHT);
        _strategyBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *zer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBackClick)];
        [_strategyBackView addGestureRecognizer:zer];
        _strategyBackView.contentMode = UIViewContentModeScaleAspectFill;
        UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_strategyBackView addSubview:centerButton];
        [centerButton addTarget:self action:@selector(strategyBackClick) forControlEvents:UIControlEventTouchUpInside];
        [centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_strategyBackView.mas_centerY).offset(40);
            make.centerX.equalTo(_strategyBackView.mas_centerX);
            make.width.height.equalTo(@120);
        }];
    }
    return _strategyBackView;
}
- (TBMakingSaveTool *)saveTool
{
    if (!_saveTool)
    {
        _saveTool = [[TBMakingSaveTool alloc] init];
    }
    return _saveTool;
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    [self updateCellRedNumber];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(244, 244, 244);
    [self configurationData];
    // 初始化 顶部 背景视图
    [self initializeView];
}

- (void)initializeView
{
    self.imageHight = 600*_SCREEN_WIDTH/1080;
    
    MJWeakSelf
 
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = RGB(244, 244, 244);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    //设置contentInset属性（上左下右 的值）
    self.collectionView.contentInset = UIEdgeInsetsMake(self.imageHight, 0, 0, 0);
    //配置ImageView
    self.zoomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:bannerName]];
    self.zoomImageView.userInteractionEnabled = YES;
    self.zoomImageView.frame = CGRectMake(0, -self.imageHight , self.view.frame.size.width, self.imageHight);
    //设置autoresizesSubviews让子类自动布局
    self.zoomImageView.autoresizesSubviews = YES;
    self.zoomImageView.clipsToBounds = YES;
    self.zoomImageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.collectionView addSubview: self.zoomImageView];
    
    UITapGestureRecognizer *zer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBanner)];
    [self.zoomImageView addGestureRecognizer:zer];
    
    [self.collectionView reloadData];
}

/**
 配置数据
 */
- (void)configurationData
{
    self.backImageNameArray =@[
    @[@{@"name":@"草稿箱",@"image":@"cgxl-icon"},@{@"name":@"待提交任务",@"image":@"dtj-icon"},@{@"name":@"已提交任务",@"image":@"ytjl-icon2"},@{@"name":@"卡券管理",@"image":@"kj-icon"}],
    @[@{@"name":@"农家乐",@"image":@"njl-icon"},@{@"name":@"休闲娱乐",@"image":@"xxyl-icon"},@{@"name":@"特色美食",@"image":@"tsms-icon"},@{@"name":@"酒店客栈",@"image":@"jdkz-icon"},@{@"name":@"景区景点",@"image":@"jqjd-icon"},@{@"name":@"服务场所",@"image":@"fwcs-icon"}]
                                ];
    
    [TBBasicDataTool initRegionData:^(TBBasicDataTool *tool) {
        
    }];
    [TBBasicDataTool initializeTypeData:^(TBBasicDataTool *tool)
     {
         
     }];
    [TBBasicDataTool initPackageData:^(NSArray<TBPackageData *> *data)
     {
         
     }];
    // 注册别名
    [self registeredAlias];
}
#pragma mark  ----更新cell上红点数量----
/**
 更新cell上红点数量
 */
- (void)updateCellRedNumber
{
    TBWeakSelf
    [self.saveTool queryConditionsResults:^(NSArray<TBMakingListMode *> *listArray)
     {
         [weakSelf queryResults:listArray];
     }];
}

// 查询结果
- (void)queryResults:(NSArray <TBMakingListMode *>*)data
{
    __block  NSInteger complete = 0;
    __block  NSInteger imperfect = 0;
    [data enumerateObjectsUsingBlock:^(TBMakingListMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.complete == 0)
        {
            complete += 1;
        }
        else
        {
            imperfect += 1;
        }
    }];
    
    self.completeNumber = complete;
    self.imperfectNumber = imperfect;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [self.collectionView reloadData];
    }];
    
}
#pragma mark  ------  UICollectionViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if(y< -self.imageHight)
    {
        CGRect frame = self.zoomImageView.frame;
        frame.origin.y = y;
        frame.size.height = -y;
        self.zoomImageView.frame = frame;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *data = self.backImageNameArray[section];
    return data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TBMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell_ID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSArray *data = self.backImageNameArray[indexPath.section];
    [cell setBackImageData:data[indexPath.row] indexPath:indexPath.section];
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]]) {
        
        [cell setTheRedDotNumber:self.completeNumber cellSection:0];
    }
    else if ([indexPath isEqual:[NSIndexPath indexPathForRow:1 inSection:0]])
    {
        [cell setTheRedDotNumber:self.imperfectNumber cellSection:0];
    }
    else
    {
        [cell removeRedDot];
    }
    return cell;
}
#pragma mark - 头部或者尾部视图
// 每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = 0.0f;
    if(indexPath.section == 1)
    {
        cellWidth = (_SCREEN_WIDTH-10*4-1)/3;
        CGSize size = {cellWidth, cellWidth*147/165};
        return size;
    }
    else
    {
        cellWidth = (_SCREEN_WIDTH-10*2)/4;
        CGSize size = {cellWidth, cellWidth};
        return size;
    }
}

/**
 定义每个Section的四边间距

 @param collectionView collectionView description
 @param collectionViewLayout collectionViewLayout description
 @param section section description
 @return return value description
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return section == 0 ? 0.0f:10.0f;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return section == 0 ? 0.0f:10.0f;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
#warning ----cs--

    TBVideoShootingController *vc = [[TBVideoShootingController alloc] init];
    vc.videoName = @"网传测试视频";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
//    [self jumpViewControllerIndexPath:indexPath];
}
#pragma mark  ----跳转页面----
- (void)jumpViewControllerIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        TBBusinessTypeViewController *typeController = [[TBBusinessTypeViewController alloc] init];
        typeController.businessType = indexPath.row;
        [self.navigationController pushViewController:typeController animated:YES];
    }
    else if (indexPath.section == 0)
    {
        if (indexPath.row == 0 || indexPath.row == 1)
        {
            TBWaitingTaskDataViewController *vc = [[TBWaitingTaskDataViewController alloc] init];
            vc.complete = indexPath.row == 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 2)
        {
            TBTaskListViewController *taskVc = [[TBTaskListViewController alloc] init];
            [self.navigationController pushViewController:taskVc animated:YES];
        }
        else if (indexPath.row == 3)
        {
            TBManagementTypeViewController *vc = [[TBManagementTypeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
#pragma mark  --攻略--
- (void)strategyBackClick
{
    [self dismissViewGostrategy:YES];
}
- (void)cancelBackClick
{
    [self dismissViewGostrategy:NO];
}
- (void)dismissViewGostrategy:(BOOL)isGo
{
    [UIView animateWithDuration:0.4 animations:^{
        self.strategyBackView.alpha = 0.05;
        self.strategyBackView.transform = CGAffineTransformMakeScale(5, 5);
    } completion:^(BOOL finished) {
        [self.strategyBackView removeFromSuperview];
        self.strategyBackView = nil;
        if (isGo == YES)
        {
            TBStrategyViewController *strategyView = [[TBStrategyViewController alloc] init];
            [self.navigationController pushViewController:strategyView animated:YES];
        }
    }];
    
}
#pragma mark  ----注册APP别名----
- (void)registeredAlias
{
    UserInfo *info  = [UserInfo account];
    NSSet *set = [[NSSet alloc] initWithObjects:info.code, nil];
    
    [JPUSHService setTags:set alias:info.phone fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        MMLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
    }];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f)
    {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"远程通知已关闭，请在“设置”-“通知”中进行修改。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            MMLog(@"推送关闭");
        }else{
            MMLog(@"推送打开");
        }
    }
}
- (void)clickBanner
{
    [[APPDELEGATE window] addSubview:self.strategyBackView];
}

@end


