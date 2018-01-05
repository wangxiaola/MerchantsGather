//
//  TBGroupManagementViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBGroupManagementViewController.h"
#import "TBGroupRecordsViewController.h"
#import "TBMoreReminderView.h"
#import "TBPublishingGroupViewController.h"
#import "TBReleasePreviewViewController.h"
#import "TBGroupManagementTableViewCell.h"
#import "TBManagementTypeMode.h"
#import "TBDiscountCouponMode.h"
#import "TBHtmlShareTool.h"
#import "WXApi.h"
static NSString *const TBGroupManagementTableViewCellID = @"TBGroupManagementTableViewCellID";

@interface TBGroupManagementViewController ()<TBGroupManagementTableViewCellDelegate>

@property (nonatomic, assign) CGFloat cellHeight;
// 是否安装过微信
@property (nonatomic, assign) BOOL isShare;

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation TBGroupManagementViewController
- (NSMutableDictionary *)dictionary
{
    if (!_dictionary)
    {
        _dictionary = [NSMutableDictionary params];
    }
    _dictionary[@"TimeStamp"]  = [ZKUtil timeStamp];
    return _dictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView.mj_header beginRefreshing];
    self.isShare = [WXApi isWXAppInstalled];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(reloadData) name:CardVoucherNotice object:nil];
}
#pragma mark --- 参数配置 ---

- (void)initData
{
    [super initData];
    self.parameter[@"interfaceId"] = @"241";
    self.parameter[@"shopid"] = [NSString stringWithFormat:@"%ld",(long)self.managementRoot.ID];
    self.parameter[@"type"] = @"tuan";
    self.parameter[@"state"] = [NSString stringWithFormat:@"%ld",(long)self.state];
    self.modeClass = [TBDiscountCouponMode class];
}
- (void)setUpView
{
    [super setUpView];
    self.cellHeight = _SCREEN_WIDTH*0.64;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TBGroupManagementTableViewCell class]) bundle:nil] forCellReuseIdentifier:TBGroupManagementTableViewCellID];
}
#pragma mark --UITableView---
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBGroupManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBGroupManagementTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.roots.count>0)
    {
        [cell updateMode:self.roots[indexPath.section] share:self.isShare];
        cell.delegate = self;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
{
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

#pragma mark --TBGroupManagementTableViewCellDelegate--
/**
 查看详情
 
 @param list 数据
 */
- (void)checkTheDetailsData:(TBDiscountCouponMode *)list;
{
    TBReleasePreviewViewController *preView = [[TBReleasePreviewViewController alloc] init];
    preView.groupId = list.ID;
    [self.navigationController pushViewController:preView animated:YES];
}
/**
 编辑修改
 
 @param list 数据
 */
- (void)editData:(TBDiscountCouponMode *)list;
{
    TBPublishingGroupViewController *groupView = [[TBPublishingGroupViewController alloc] init];
    groupView.groupId = list.ID;
    groupView.shopname = self.managementRoot.name;
    [self.navigationController pushViewController:groupView animated:YES];
}
/**
 删除活动
 
 @param list 数据
 */
- (void)deleteActivitiesData:(TBDiscountCouponMode *)list;
{
    TBMoreReminderView *moreView = [[TBMoreReminderView alloc] initShowPrompt:@"确认删出该活动吗？"];
    TBWeakSelf
    [moreView showHandler:^{
        [weakSelf requestData:list];
    }];
}
/**
 分享活动
 
 @param list 数据
 */
- (void)sharingActivitiesData:(TBDiscountCouponMode *)list;
{
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",GROUP_SHARE,list.ID];
    NSString *name = [NSString stringWithFormat:@"[团购秒杀] %@--%@",self.managementRoot.name,list.name];
    NSString *info = [NSString stringWithFormat:@"现价%@元/份，原价%@元/份，限量抢购！",list.price,list.origin];
    
    TBHtmlShareTool *shareTool = [[TBHtmlShareTool alloc] init];
    [shareTool showWXTitle:name deacription:info image:list.logo webpageUrl:shareUrl];
}
/**
 购买记录
 
 @param list 数据
 */
- (void)purchaseRecordsData:(TBDiscountCouponMode *)list;
{
    list.shopname = self.managementRoot.name;
    TBGroupRecordsViewController *vc = [[TBGroupRecordsViewController alloc] init];
    vc.list = list;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --数据请求处理---
// 删除数据
- (void)requestData:(TBDiscountCouponMode *)mode
{
    [self.dictionary setObject:@"240" forKey:@"interfaceId"];
    [self.dictionary setObject:mode.ID forKey:@"id"];
    TBWeakSelf
    hudShowLoading(@"正在删除");
    [ZKPostHttp post:@"" params:self.dictionary success:^(id responseObj) {
        
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        NSString *errmsg = [responseObj valueForKey:@"errmsg"];
        if ([errcode isEqualToString:@"00000"])
        {
            [weakSelf.roots removeObject:mode];
            [weakSelf.tableView reloadData];
            hudShowSuccess(errmsg);
        }
        else
        {
            hudShowError(errmsg);
        }
    } failure:^(NSError *error) {
        hudShowError(@"删除失败");
    }];
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
