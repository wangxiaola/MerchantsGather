//
//  TBGroupRecordsViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/13.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBGroupRecordsViewController.h"
#import "TBVouchersRecordTableViewCell.h"
#import "TBGroupRecordsHeadView.h"
#import "TBGroupRecordsMode.h"
#import "TBDiscountCouponMode.h"

static NSString *const TBGroupRecordsTableViewCellID = @"TBGroupRecordsTableViewCellID";

@interface TBGroupRecordsViewController ()
@property (nonatomic, strong) TBGroupRecordsHeadView *headView;
@end

@implementation TBGroupRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"购买记录";
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark --- 参数配置 ---

- (void)initData
{
    [super initData];
    self.parameter[@"interfaceId"] = @"234";
    self.parameter[@"id"] = self.list.ID;
    self.modeClass = [TBGroupRecordsMode class];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
- (void)setUpView
{
    [super setUpView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TBVouchersRecordTableViewCell class]) bundle:nil] forCellReuseIdentifier:TBGroupRecordsTableViewCellID];

    //得到第一个UIView
    self.headView =  [[NSBundle mainBundle]loadNibNamed:@"TBGroupRecordsHeadView" owner:self options:nil].firstObject;
    self.headView.backgroundColor = [UIColor whiteColor];
    //添加视图
    [self.view addSubview:self.headView];
    
   TBWeakSelf
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.height.equalTo(@110);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.headView.mas_bottom).offset(1);
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
        self.list.total = total;

    }
     self.headView.list = self.list;
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
    TBVouchersRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBGroupRecordsTableViewCellID];
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
