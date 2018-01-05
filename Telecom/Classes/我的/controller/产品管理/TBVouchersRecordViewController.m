//
//  TBVouchersRecordViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//


#import "TBVouchersRecordViewController.h"
#import "TBVouchersRecordTableViewCell.h"
#import "TBVouchersRecordMode.h"
#import "TBDiscountsMode.h"

static NSString *const TBVouchersRecordTableViewCellID = @"TBVouchersRecordTableViewCellID";

@interface TBVouchersRecordViewController ()

@property (nonatomic, strong) UILabel *priceLabel;//价格
@property (nonatomic, strong) UILabel *totalNumberLabel;//总数量
@property (nonatomic, strong) UILabel *receiveNumberLabel;//领取数量

@end

@implementation TBVouchersRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"领取记录";
    [self.tableView.mj_header beginRefreshing];
    
    if (self.mode)
    {
        NSString *unitString = [self.mode.type isEqualToString:@"ka"]?@"打折卡":@"元现金抵用券";
        NSString *priceString = [NSString stringWithFormat:@"%@%@",self.mode.money1.integerValue == 0?self.mode.money:self.mode.money1,unitString];
        self.priceLabel.attributedText = [ZKUtil ls_changeFontAndColor:[UIFont systemFontOfSize:18] Color:[UIColor blackColor] TotalString:priceString SubStringArray:@[@"元现金抵用券"]];
        
        NSString *num = [NSString stringWithFormat:@"%@",self.mode.num];
        NSString *totalNumberString = [NSString stringWithFormat:@"共%@份",num];
        self.totalNumberLabel.attributedText = [ZKUtil ls_changeFontAndColor:[UIFont systemFontOfSize:15] Color:RGB(203, 45, 26) TotalString:totalNumberString SubStringArray:@[num]];
    }
}

#pragma mark --- 参数配置 ---

- (void)initData
{
    [super initData];
    self.parameter[@"interfaceId"] = @"233";
    self.parameter[@"state"] = self.mode.ID;
    self.parameter[@"type"] = @"tuan";
    self.modeClass = [TBVouchersRecordMode class];
}
- (void)setUpView
{
    [super setUpView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TBVouchersRecordTableViewCell class]) bundle:nil] forCellReuseIdentifier:TBVouchersRecordTableViewCellID];
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = RGB(203, 45, 26);
    self.priceLabel.font = [UIFont systemFontOfSize:18];
    [footView addSubview:self.priceLabel];
    
    self.totalNumberLabel = [[UILabel alloc] init];
    self.totalNumberLabel.textColor = [UIColor blackColor];
    self.totalNumberLabel.font = [UIFont systemFontOfSize:14];
    [footView addSubview:self.totalNumberLabel];
    
    self.receiveNumberLabel = [[UILabel alloc] init];
    self.receiveNumberLabel.textColor = [UIColor blackColor];
    self.receiveNumberLabel.font = [UIFont systemFontOfSize:14];
    [footView addSubview:self.receiveNumberLabel];
    TBWeakSelf
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.height.equalTo(@46);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView.mas_left).offset(10);
        make.centerY.equalTo(footView.mas_centerY);
        make.right.mas_greaterThanOrEqualTo(weakSelf.receiveNumberLabel.mas_left).offset(-10);
    }];
    
    [self.totalNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footView.mas_right).offset(-10);
        make.centerY.equalTo(footView.mas_centerY);
    }];
    [self.receiveNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.totalNumberLabel.mas_left);
        make.centerY.equalTo(footView.mas_centerY);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(footView.mas_bottom).offset(1);
    }];
}
#pragma mark ---TBManagementViewModeDelegate--
/**
 原生数据
 
 @param dictionary 数据
 */
- (void)originalData:(NSDictionary *)dictionary;
{
    NSString *total = [NSString stringWithFormat:@"%@",[[dictionary valueForKey:@"data"] valueForKey:@"total"]];
    if (total!=nil)
    {
        NSString *receiveNumberString = [NSString stringWithFormat:@"已领取%@份，",total];
        self.receiveNumberLabel.attributedText = [ZKUtil ls_changeFontAndColor:[UIFont systemFontOfSize:15] Color:RGB(23, 181, 146) TotalString:receiveNumberString SubStringArray:@[total]];
    }
}

#pragma mark --UITableView---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.roots.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBVouchersRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBVouchersRecordTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.roots.count>0)
    {
        [cell updataCellData:self.roots[indexPath.row] showTopView:indexPath.row == 0];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
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
