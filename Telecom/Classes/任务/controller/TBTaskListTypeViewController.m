//
//  TBTaskListTypeViewController.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/8.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTaskListTypeViewController.h"
#import "TBBasicDataTool.h"
#import "TBErrorCorrectionViewController.h"
#import "TBFinancialActivateViewController.h"

#import "TBHtmlShareTool.h"
#import "TBReviewTipsPopView.h"
#import "TBStopBusinessViewController.h"
#import "TBTaskListMode.h"
#import "TBTaskMakeViewController.h"
#import "TBTemplateChooseCollectionViewController.h"
#import "TBWebViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIView+UIScreenDisplaying.h"
#import "WXApi.h"

@interface TBTaskListTypeViewController ()<TBTaskListTableViewCellDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) BOOL isSearch;//是否正在搜索
@property (nonatomic) Tasktype controllerTasktype;
@property (nonatomic, assign) BOOL isShare;// 是否安装过微信
@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, strong) NSMutableArray <TBTaskListRoot*>*rootArray;
@property (nonatomic, strong) UILabel *recordLabel;// 记录
@property (nonatomic, strong) NSString *modelid;
@end

@implementation TBTaskListTypeViewController

- (NSMutableArray<TBTaskListRoot *> *)rootArray
{
    if (!_rootArray)
    {
        _rootArray = [NSMutableArray array];
    }
    
    return _rootArray;
}
- (instancetype)initType:(Tasktype)type;
{
    self = [super init];
    if (self)
    {
        self.controllerTasktype = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.isShare = [WXApi isWXAppInstalled];
    // Do any additional setup after loading the view.
}
#pragma mark ---初始化视图----
- (void)initView
{
    self.title = @"任务";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 1)];
    self.recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 24)];
    self.recordLabel.backgroundColor = [UIColor clearColor];
    self.recordLabel.font = [UIFont systemFontOfSize:15 weight:0.2];
    self.recordLabel.textColor = [UIColor orangeColor];
    self.recordLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = self.recordLabel;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TBTaskListTableViewCell" bundle:nil] forCellReuseIdentifier:TBTaskListTableViewCellID];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.page = 1;
    self.key = @"";
    self.modelid = @"";
    
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    self.tableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingData)];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(reloadData) name:TaskToInform object:nil];
    [self.tableView.mj_header beginRefreshing];
    
    self.typeArray = [TBBasicDataTool businessType];
}

#pragma mark   --- 数据请求 ----
- (void)requestDataSearch:(NSString*)key searchCode:(NSString *)code;
{
    self.key = key.length == 0?@"":key;
    self.modelid = code.length == 0?@"":code;
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
    dic[@"state"] = [NSNumber numberWithInteger:self.controllerTasktype];
    dic[@"code"] = @"";
    dic[@"modelid"] = self.modelid;
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
        //        [UIView addMJNotifierWithText:@"没有数据了" dismissAutomatically:YES];
    }
    else if (responseObject.data.shops.root.count == responseObject.data.shops.total)// 数据加载完
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
        //        [UIView addMJNotifierWithText:@"数据已全部加载" dismissAutomatically:YES];
    }
    
    
    [self recordNumber:responseObject.data.shops.total];
    [self.rootArray addObjectsFromArray:responseObject.data.shops.root];
    hudDismiss();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
    
    
}
//  记录数字
- (void)recordNumber:(NSInteger)number
{
    NSString *recordStr = [NSString stringWithFormat:@"共有 %ld 个记录",(long)number];
    
    self.recordLabel.attributedText = [ZKUtil ls_changeFontAndColor:[UIFont systemFontOfSize:14] Color:[UIColor blackColor] TotalString:recordStr SubStringArray:@[@"共有",@"个记录"]];
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
    
    TBTaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBTaskListTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.rootArray.count >0)
    {
        [cell updateMode:self.rootArray[indexPath.section] share:self.isShare taskStatus:self.controllerTasktype];
    }
    cell.delegate = self;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rootArray.count >0)
    {
        [self cellDidSelectType:self.rootArray[indexPath.section]];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rootArray.count == 0)
    {
        return _SCREEN_HEIGHT;
    }
    else
    {
        return UITableViewAutomaticDimension;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
// cell点击处理
- (void)cellDidSelectType:(TBTaskListRoot *)list
{
    if (![list.code isEqualToString:@"service"])
    {
        //查看
        TBWebViewController *vc = [[TBWebViewController alloc] init];
        [vc loadWebURLSring:HTML_URL(list.ID)];
        vc.root = list;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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

#pragma mark ---TBTaskListTableViewCellDelegate--
/**
 点击编辑
 
 @param data 数据
 */
- (void)taskCellClickEditorMode:(TBTaskListRoot *)data;
{
    
    NSInteger typeID = 0;
    for (NSDictionary *obj in self.typeArray) {
        if ([[obj valueForKey:@"type"] isEqualToString:data.code])
        {
            typeID = [[obj valueForKey:@"ID"] integerValue];
        }
    }
    TBTaskMakeViewController *vc = [[TBTaskMakeViewController alloc] init];
    vc.merchantsID = data.ID;
    vc.typeID = typeID;
    vc.templateType = TBMakingProductionModifyThe;
    vc.type = data.code;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 点击审核详情
 
 @param data 数据
 */
- (void)taskCellClickDetailsMode:(TBTaskListRoot *)data;
{
    
    TBReviewTipsPopView *popView = [[TBReviewTipsPopView alloc] init];
    [popView showTime:data.time content:data.info];
}
/**
 点击营业状态
 
 @param data 数据
 */
- (void)taskCellClickBusinessMode:(TBTaskListRoot *)data;
{
    
    TBStopBusinessViewController *businessVC = [[TBStopBusinessViewController alloc] init];
    businessVC.root = data;
    [self.navigationController pushViewController:businessVC animated:YES];
}
/**
 点击分享
 
 @param data 数据
 */
- (void)taskCellClickShareMode:(TBTaskListRoot *)data;
{
    TBHtmlShareTool *shareView = [[TBHtmlShareTool alloc] init];
    NSString *str = [NSString stringWithFormat:@"电话：%@\r\n地址：%@",data.tel,data.address];
    [shareView showWXTitle:data.name deacription:str image:data.img webpageUrl:HTML_URL(data.ID)];
    
}
/**
 点击激活
 
 @param data 数据
 */
- (void)taskCellClickActivationMode:(TBTaskListRoot *)data;
{
    TBFinancialActivateViewController *vc = [[TBFinancialActivateViewController alloc] initMerchantsPhone:data.tel];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
