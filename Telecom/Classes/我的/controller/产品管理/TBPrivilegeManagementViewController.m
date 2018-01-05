//
//  TBPrivilegeManagementViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBPrivilegeManagementViewController.h"
#import "TBReleaseCardVoucherViewController.h"
#import "TBVouchersRecordViewController.h"
#import "TBOfferDetailsViewController.h"
#import "TBDiscountsListTableViewCell.h"
#import "TBManagementTypeMode.h"
#import "TBDiscountsMode.h"
#import "TBMoreReminderView.h"

static NSString *const TBDiscountsTypeTableViewCellID = @"TBDiscountsTypeTableViewCellID";

@interface TBPrivilegeManagementViewController ()<TBDiscountsTableViewCellDelegate>

@property (nonatomic, assign) CGFloat backImageHeight;
@property (nonatomic, strong) NSMutableDictionary *cardDic;

@end

@implementation TBPrivilegeManagementViewController
- (NSMutableDictionary *)cardDic
{
    if (!_cardDic)
    {
        _cardDic = [NSMutableDictionary params];
    }
    return _cardDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [UIImage imageNamed:@"Discounts_r"];
    
    self.backImageHeight = (_SCREEN_WIDTH-16)/(image.size.width/image.size.height);
    [self.tableView.mj_header beginRefreshing];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(reloadData) name:CardVoucherNotice object:nil];

}
#pragma mark --- 参数配置 ---

- (void)initData
{
    [super initData];
    self.parameter[@"interfaceId"] = @"232";
    self.parameter[@"shopid"] = [NSString stringWithFormat:@"%ld",(long)self.managementRoot.ID];
    self.parameter[@"type"] = self.managementType == ManagementTypeVouchers?@"hong":@"ka";
    self.parameter[@"state"] = [NSString stringWithFormat:@"%ld",(long)self.state];
    self.modeClass = [TBDiscountsMode class];
}
- (void)setUpView
{
    [super setUpView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TBDiscountsListTableViewCell class]) bundle:nil] forCellReuseIdentifier:TBDiscountsTypeTableViewCellID];
}
#pragma mark --UITableView---
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TBDiscountsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBDiscountsTypeTableViewCellID];
    cell.deleaget = self;
    if (self.roots.count>0)
    {
        TBDiscountsMode *mode = self.roots[indexPath.section];
    
        if (cell)
        {
            [cell updataDiscountsCellInfo:mode backImageHeight:self.backImageHeight cellType:self.managementType];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.backImageHeight+44;
}
#pragma mark --TBDiscountsTableViewCellDelegate--
/**
 查看详情
 
 @param list 数据
 */
- (void)checkTheDetailsData:(TBDiscountsMode *)list;
{
    list.type = self.managementType == ManagementTypeVouchers?@"hong":@"ka";
    list.shopname = self.managementRoot.name;
    TBOfferDetailsViewController *vc = [[TBOfferDetailsViewController alloc] init];
    vc.mode = list;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 领取记录
 
 @param list 数据
 */
- (void)getTheRecordData:(TBDiscountsMode *)list;
{
    TBVouchersRecordViewController *vc = [[TBVouchersRecordViewController alloc] init];
    list.type = self.managementType == ManagementTypeVouchers?@"hong":@"ka";
    vc.mode = list;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 编辑修改
 
 @param list 数据
 */
- (void)editData:(TBDiscountsMode *)list;
{
    NSInteger type = self.managementType;
    TBReleaseCardVoucherViewController *vc = [[TBReleaseCardVoucherViewController alloc] initReleaseType:type shopid:[NSString stringWithFormat:@"%ld",(long)self.managementRoot.ID]];
    vc.list = list;
    [self.navigationController pushViewController:vc animated:YES];
    
}
/**
 删除
 
 @param list 数据
 */
- (void)deleteData:(TBDiscountsMode *)list;
{
    TBMoreReminderView *reminderView = [[TBMoreReminderView alloc] initShowPrompt:@"是否要删除当前卡券?"];
    TBWeakSelf
    [reminderView showHandler:^{
        [weakSelf deleteCardVoucherData:list];
    }];
}
#pragma mark ---数据删除---
- (void)deleteCardVoucherData:(TBDiscountsMode *)data
{
    hudShowLoading(@"正在删除");
    self.cardDic[@"id"] = data.ID;
    self.cardDic[@"interfaceId"] = @"238";
    TBWeakSelf
    [ZKPostHttp post:@"" params:self.cardDic success:^(id responseObj) {
        
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        NSString *errmsg = [responseObj valueForKey:@"errmsg"];
        if ([errcode isEqualToString:@"00000"])
        {
            hudShowSuccess(errmsg);
            [weakSelf.roots removeObject:data];
            [weakSelf.tableView reloadData];
        }
        else
        {
            hudShowError(errmsg);
        }
        
    } failure:^(NSError *error) {
        hudShowError(@"网络异常!");
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
