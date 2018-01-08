//
//  TBWaitingTaskDataViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "AFNetworkReachabilityManager.h"
#import "TBBasicDataTool.h"

#import "TBHistoricalDataUpload.h"
#import "TBMakingListMode.h"
#import "TBMakingSaveTool.h"
#import "TBMoreReminderView.h"
#import "TBTaskMakeViewController.h"
#import "TBWaitingTaskDataTableViewCell.h"
#import "TBWaitingTaskDataViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "UIScrollView+EmptyDataSet.h"
#import "YPTabBar.h"

@interface TBWaitingTaskDataViewController ()<UITableViewDataSource,UITableViewDelegate,YPTabBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) TBHistoricalDataUpload *uploadTool;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footHeight;
@property (strong, nonatomic) YPTabBar *tabBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footBackView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) TBMakingSaveTool *saveTool;
@property (strong, nonatomic) NSString *searchKey;

@property (strong, nonatomic) NSArray *selectArray;
//总数据
@property (strong, nonatomic) NSMutableArray <TBMakingListMode *>*allArray;
//记录选择结果数据
@property (strong, nonatomic) NSMutableArray <TBMakingListMode *>*recordArray;
//展示数据
@property (strong, nonatomic) NSMutableArray <TBMakingListMode *>*showArray;

@property (nonatomic, strong) NSArray <TBPackageData *>*packageData;

@property (nonatomic) AFNetworkReachabilityStatus workStatus;//网络状态

@end

@implementation TBWaitingTaskDataViewController

#pragma mark --- data ---
- (void)takeOutTheData
{
    [self.allArray removeAllObjects];
    [self.showArray removeAllObjects];
    [self.recordArray removeAllObjects];
    
    TBWeakSelf
    [self.saveTool queryConditionsResults:^(NSArray<TBMakingListMode *> *listArray)
     {
         [weakSelf queryResults:listArray];
     }];
    
    if (self.packageData.count == 0)
    {
        [TBBasicDataTool initPackageData:^(NSArray<TBPackageData *> *array) {
            weakSelf.packageData = array;
            [weakSelf updataTableView];
        }];
    }
    
}
// 查询结果
- (void)queryResults:(NSArray <TBMakingListMode *>*)data
{
    [data enumerateObjectsUsingBlock:^(TBMakingListMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.complete == self.complete)
        {
            [self.allArray addObject:obj];
        }
    }];
    [self.showArray addObjectsFromArray:self.allArray];
    [self queryDataKey:self.searchKey];
}

/**
 主线程刷新
 */
- (void)updataTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark -- 头部选择view配置 ---
- (void)initItmeView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem setRitWithTitel:@"编辑" itemWithIcon:nil target:self action:@selector(editAction)];
    [self.headerView addSubview:self.tabBarView];
    self.tabBarView.delegate = self;
    self.tabBarView.backgroundColor = [UIColor whiteColor];
    self.tabBarView.itemSelectedBgColor = NAVIGATION_COLOR;
    self.tabBarView.itemTitleColor = [UIColor grayColor];
    self.tabBarView.itemTitleSelectedColor = [UIColor whiteColor];
    self.tabBarView.itemTitleFont = [UIFont systemFontOfSize:13];
    self.tabBarView.itemTitleSelectedFont = [UIFont systemFontOfSize:13];
    self.tabBarView.leftAndRightSpacing = 20;
    self.tabBarView.itemSelectedBgCornerRadius = self.tabBarView.frame.size.height/2;
    [self.tabBarView setScrollEnabledAndItemFitTextWidthWithSpacing:14];
    self.selectArray = [TBBasicDataTool businessType];
    [self.tabBarView setTitles:@[@"全部",@"农家乐",@"休闲娱乐",@"特色美食",@"酒店客栈",@"景区景点",@"服务场所",]];
    self.tabBarView.selectedItemIndex = 0;
    self.searchKey = @"";
    
    
}
#pragma mark ---视图配置---
- (void)viewTheConfiguration
{
    self.title = self.complete?@"待提交任务":@"草稿箱";
    self.footHeight.constant = 0.01;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tabBarView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TBWaitingTaskDataTableViewCell" bundle:nil] forCellReuseIdentifier:TBWaitingTaskDataTableViewCellID];
    if (self.complete)
    {
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        self.submitButton.layer.cornerRadius = 4;
        self.deleteButton.layer.cornerRadius = 4;
        self.footBackView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.footBackView.layer.shadowOffset = CGSizeMake(0,-4);
        self.footBackView.layer.shadowOpacity = 0.5;
        self.footBackView.layer.shadowRadius = 4;
    }
    [self.tableView reloadData];
    
}
#pragma mark ---YPTabBarDelegate---
/**
 *  已经切换到指定index
 */
- (void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index;
{
    NSString *key ;
    if (index == 0)
    {
        key = @"";
    }
    else
    {
        NSDictionary *dic =  [self.selectArray objectAtIndex:index-1];
        key = [dic valueForKey:@"type"];
    }
    
    if (self.recordArray.count >0)
    {    TBWeakSelf
        TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，切换类型，选择的数据将清空，是否继续?"];
        [more showHandler:^{
            hudShowLoading(@"查询中");
            [weakSelf queryDataKey:key];
        }];
    }
    else if (self.allArray.count>0)
    {
        hudShowLoading(@"查询中");
        [self queryDataKey:key];
    }
}
- (void)queryDataKey:(NSString *)key
{
    self.searchKey = key;
    [self.showArray removeAllObjects];
    [self.recordArray removeAllObjects];
    
    if (key.length == 0)
    {
        [self.showArray addObjectsFromArray:self.allArray];
    }
    else
    {
        [self.allArray enumerateObjectsUsingBlock:^(TBMakingListMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([self.searchKey isEqualToString:obj.type])
            {
                [self.showArray addObject:obj];
            }
        }];
    }
    
    hudDismiss();
    [self updataTableView];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (self.tableView.editing == YES)
        {
            [self updataFootState];
        }
    }];
}
#pragma mark ---UITableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.showArray.count;
}
//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TBMakingListMode *mode = self.showArray[indexPath.section];
    
    if (self.complete == YES && self.tableView.editing == YES)
    {
        [self.recordArray addObject:mode];
        [self updataFootState];
    }
    else
    {
        [self jumpController:mode];
    }
    
}
// 跳转到详情
- (void)jumpController:(TBMakingListMode *)mode
{
    TBWeakSelf
    TBTaskMakeBaseViewViewController *vc = [[TBTaskMakeViewController alloc] init];
    vc.makingList = mode;
    vc.type = mode.type;
    [vc setDataStatusChange:^{
        [weakSelf  takeOutTheData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//取消选中
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.complete == YES)
    {
        TBMakingListMode *mode = self.showArray[indexPath.section];
        [self.recordArray removeObject:mode];
        [self updataFootState];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//设置编辑风格EditingStyle

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.complete == YES)
    {
        //当表视图处于没有未编辑状态时选择多选删除
        return UITableViewCellEditingStyleInsert;
    }
    else
    {
        //当表视图处于没有未编辑状态时选择左滑删除
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，确定删除选中的数据吗？"];
        [more showHandler:^{
            
            [self deleteMarkLists:[NSArray arrayWithObject:[self.showArray objectAtIndex:indexPath.section]] showHudL:YES];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
        }];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBWaitingTaskDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBWaitingTaskDataTableViewCellID];
    
    if (cell == nil) {
        
        cell = [[TBWaitingTaskDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TBWaitingTaskDataTableViewCellID];
    }
    if (self.showArray.count>0)
    {
        [cell updataCell:self.showArray[indexPath.section] packageArray:self.packageData];
    }
    cell.tintColor = RGB(250, 131, 8);
    cell.selectedBackgroundView = [[UIView alloc] init];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
    hudShowLoading(@"加载中...");
    [self queryDataKey:self.searchKey];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;
{
    hudShowLoading(@"加载中...");
    [self queryDataKey:self.searchKey];
}

#pragma mark --- 点击事件 ----
- (void)editAction
{
    self.footHeight.constant = self.complete?50:0.01;
    self.tableView.editing = YES;
    [self.recordArray removeAllObjects];
    [self updataFootState];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem setRitWithTitel:@"退出" itemWithIcon:nil target:self action:@selector(exitEdit)];
}
- (void)exitEdit
{
    self.footHeight.constant = 0.01;
    self.tableView.editing = NO;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem setRitWithTitel:@"编辑" itemWithIcon:nil target:self action:@selector(editAction)];
}
- (IBAction)deleteButtonClick:(UIButton *)sender
{
    if (self.recordArray.count == 0)
    {
        hudShowInfo(@"请先选择你要删除的数据!");
    }
    else
    {
        TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，确定删除选中的数据吗？"];
        [more showHandler:^{
            
            [self deleteMarkLists:self.recordArray showHudL:YES];
            
        }];
    }
    
}
- (IBAction)submitButtonClick:(UIButton *)sender
{
    if (self.recordArray.count == 0)
    {
        hudShowInfo(@"请先选择你要提交的数据!");
    }
    else
    {
        TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，确定提交选中的数据吗？"];
        TBWeakSelf
        [more showHandler:^{
            
            if (weakSelf.workStatus == AFNetworkReachabilityStatusUnknown)
            {
                hudShowError(@"网络连接异常!");
            }
            else if (weakSelf.workStatus == AFNetworkReachabilityStatusNotReachable)
            {
                // 不可达的网络(未连接)
                hudShowError(@"网络异常!");
            }
            else if (weakSelf.workStatus == AFNetworkReachabilityStatusReachableViaWWAN)
            {
                // 2G,3G,4G...的网络
                [weakSelf showPrompt:@"当前网络非WiFi连接,是否继续上传资源信息?"];
            }
            else if (weakSelf.workStatus == AFNetworkReachabilityStatusReachableViaWiFi)
            {
                // wifi的网络
                [weakSelf updataModes:weakSelf.recordArray];
            }
        }];
    }
}
- (void)showPrompt:(NSString *)stateInfo
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:stateInfo preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"任性上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updataModes:self.recordArray];
    }]];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (IBAction)selectButtonClick:(UIButton *)sender
{
    BOOL select  = self.showArray.count == self.recordArray.count;
    [self.recordArray removeAllObjects];
    if (select == NO)
    {
        // 全选
        select = YES;
        [self.recordArray addObjectsFromArray:self.showArray];
    }
    else
    {
        // 取消选中
        select = NO;
    }
    [self cellSelected:select];
    [self updataFootState];
}

/**
 更新数字栏显示
 */
- (void)updataFootState
{
    NSString *imageUrl = @"";
    if (self.showArray.count == self.recordArray.count)
    {
        if (self.showArray.count == 0)
        {
            imageUrl = @"task-choice";
        }
        else
        {
            imageUrl = @"task-choice-hover";
        }
    }
    else
    {
        imageUrl = @"task-choice";
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.recordArray.count];
    [self.selectButton setImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
}
// cell选择状态
- (void)cellSelected:(BOOL)send
{
    [self.showArray enumerateObjectsUsingBlock:^(TBMakingListMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (send == YES)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
            [self.tableView selectRowAtIndexPath:indexPath animated:send scrollPosition:UITableViewScrollPositionNone];
        }
        else
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:idx];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
    }];
}
#pragma mark ----数据上传---
- (void)updataModes:(NSArray <TBMakingListMode *>*)array
{
    TBWeakSelf
    [self.uploadTool updataArray:array deleteArray:^(NSArray<TBMakingListMode *> *lsArray)
     {
         [weakSelf postState:array.count-lsArray.count deleteArray:lsArray];
         
     }];
}
- (void)postState:(NSInteger )number deleteArray:(NSArray<TBMakingListMode *>*)array
{
    if (number == 0)
    {
        hudShowSuccess(@"数据上传完成");
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"有%lu条数据提交失败",(long)number];
        hudShowInfo(msg);
    }
    [self deleteMarkLists:array showHudL:NO];
}
#pragma mark --- 数据更改---
- (void)deleteMarkLists:(NSArray <TBMakingListMode *>*)list showHudL:(BOOL)show
{
    if (show)
    {
        hudShowLoading(@"删除中...");
    }
    TBWeakSelf
    [self.saveTool deleteMakingListArray:list deleteState:^(BOOL state)
     {
         if (show)
         {
             hudShowSuccess(@"删除成功。");
         }
         [weakSelf.showArray removeObjectsInArray:list];
         [weakSelf.allArray removeObjectsInArray:list];
         [weakSelf.recordArray removeAllObjects];
         [weakSelf updataTableView];
         [weakSelf updataFootState];
     }];
    
    
}
#pragma mark --- 监听网络状态---
/**
 监听网络状态
 */
- (void)workReachability
{
    //创建网络监听管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         self.workStatus = status;
     }];
    //开始监听
    [manager startMonitoring];
}
#pragma mark --工具准备--
- (TBHistoricalDataUpload *)uploadTool
{
    if (!_uploadTool)
    {
        _uploadTool = [[TBHistoricalDataUpload alloc] init];
    }
    return _uploadTool;
}
- (NSMutableArray<TBMakingListMode *> *)showArray
{
    if (!_showArray)
    {
        _showArray = [NSMutableArray array];
    }
    return _showArray;
}
- (NSMutableArray<TBMakingListMode *> *)recordArray
{
    if (!_recordArray)
    {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}
- (TBMakingSaveTool *)saveTool
{
    if (!_saveTool)
    {
        _saveTool = [[TBMakingSaveTool alloc] init];
    }
    return _saveTool;
}
- (NSMutableArray<TBMakingListMode *> *)allArray
{
    if (!_allArray)
    {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
}
- (YPTabBar *)tabBarView
{
    if (!_tabBarView)
    {
        _tabBarView = [[YPTabBar alloc] initWithFrame:CGRectMake(0, (44-26)/2, _SCREEN_WIDTH, 26)];
    }
    return _tabBarView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewTheConfiguration];
    [self initItmeView];
    [self workReachability];
    hudShowLoading(@"数据查询中");
    [self takeOutTheData];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIView dismissMJNotifier];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
