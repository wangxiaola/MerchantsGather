//
//  TBGZPeopleStatisticsViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/11/17.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBGZPeopleStatisticsViewController.h"
#import "TBInServiceAreaView.h"
@interface TBGZPeopleStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *infoDictionary;

@property (nonatomic, strong) NSArray *baseData;

@end

@implementation TBGZPeopleStatisticsViewController

- (instancetype)initShowData:(NSDictionary *)data;
{
    if (self = [super init])
    {
        self.infoDictionary = data;
    }
    return self;
}
- (NSArray *)baseData
{
    if (!_baseData)
    {
        _baseData = [NSArray arrayWithObjects:
                     @[@"35岁以下员工人数",@"36-65岁员工人数",@"65岁以上员工人数"],
                     @[@"薪资月收入最低",@"薪资月收入最高",@"每人平均月收入"],
                     @[@"男性员工人数",@"女性员工人数",@"就业员工总人数"],nil];
    }
    return _baseData;
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _tableView.tableHeaderView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 10)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableView;
}
#pragma mark  ----视图创建----
// 视图创建
- (void)createAview;
{
    self.navigationItem.title = @"贫困人员统计表";
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIButton *hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hiddenButton setTitle:@"返 回" forState:UIControlStateNormal];
    [hiddenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hiddenButton.titleLabel.font = [UIFont systemFontOfSize:18];
    hiddenButton.backgroundColor = NAVIGATION_COLOR;
    [hiddenButton addTarget:self action:@selector(hiddenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    hiddenButton.layer.cornerRadius = 4;
    [self.view addSubview:hiddenButton];
    
    CGFloat bottomFloat = 0;
    if (_SCREEN_HEIGHT == 812) {
        bottomFloat = 34;
    }
    
    TBWeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-50-bottomFloat);
    }];
    [hiddenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.equalTo(@44);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-3-bottomFloat);
    }];
}
- (void)hiddenButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark --UITableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tatol = [self.baseData objectAtIndex:section];
    return tatol.count;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 44;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 )
    {
        TBInServiceAreaView *headerView = [[TBInServiceAreaView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 44)];
        headerView.backgroundColor = [UIColor whiteColor];
        [headerView headAssignment:@"商户人员信息"];
        return headerView;
    }
    return [[UIView alloc] init];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    
    if (!textFieldCell)
    {
        textFieldCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Identifier"];
        textFieldCell.textLabel.textColor = [UIColor blackColor];
        textFieldCell.textLabel.font = [UIFont systemFontOfSize:14];
        textFieldCell.detailTextLabel.textColor = [UIColor grayColor];
        textFieldCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    
    NSString *name = [[self.baseData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    textFieldCell.textLabel.text = name;
    
    if (self.infoDictionary.count >0)
    {
        NSString *key = [self accessToKeyCellForRowAtIndexPath:indexPath];
        NSString *results = [self.infoDictionary valueForKey:key];
        textFieldCell.detailTextLabel.text = results;
    }
    
    textFieldCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return textFieldCell;
}
#pragma mark  ----tool----
- (NSString *)accessToKeyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *key = @"";
    
    switch (section) {
        case 2:// 第三个区
            
            switch (row) {
                    
                case 0:
                    key = @"menNum";
                    break;
                case 1:
                    key = @"womanNum";
                    break;
                case 2:
                    key = @"totalNum";
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1://第二个区
            
            switch (row) {
                    
                case 0:
                    key = @"lowSalary";
                    break;
                case 1:
                    
                    key = @"highSalary";
                    break;
                case 2:
                    key = @"averageIncome";
                    break;
                default:
                    break;
            }
            break;
            
        case 0://第一个区
            
            switch (row) {
                case 0:
                    key = @"below35Num";
                    break;
                    break;
                case 1:
                    key = @"below65Num";
                    break;
                case 2:
                    key = @"above65Num";
                    break;
            }
            break;
            
        default:
            break;
    }
    
    return key;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createAview];
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
