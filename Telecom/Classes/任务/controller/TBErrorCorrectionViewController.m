//
//  TBErrorCorrectionViewController.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/8.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBErrorCorrectionViewController.h"
#import "TBTaskListMode.h"
#import "TBTemplateInfoTableViewCell.h"
#import "TBNoteTableViewCell.h"
#import "ZKPickDataView.h"
#import "TBBasicDataTool.h"

@interface TBErrorCorrectionViewController ()<UITableViewDelegate,UITableViewDataSource,ZKPickDataViewDelegate>

@property (nonatomic, strong) NSArray *lefNameArray;

@property (nonatomic, strong) NSArray *ritNameArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TBBasicDataTool *dataTool;

@property (nonatomic, strong) TBBasicDataShoptypes *shops;

@end

@implementation TBErrorCorrectionViewController

static NSString*const  reuseIdentifier_info = @"cell_info";
static NSString*const  reuseIdentifier_label = @"cell_label";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商家纠错";
    [self upTableView];
    TBWeakSelf
   [TBBasicDataTool initializeTypeData:^(TBBasicDataTool *tool) {
       
       weakSelf.dataTool = tool;
   }];
}

- (void)upTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TBTemplateInfoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_info];
    [self.tableView registerNib:[UINib nibWithNibName:@"TBNoteTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_label];
    self.lefNameArray = @[@"商家类型纠错",@"名称纠错",@"地址纠错",@"电话纠错"];
    self.ritNameArray = @[@"请选择正确的商家类型",@"请输入正确名称",@"请输入正确地址",@"请输入正确电话"];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.backgroundColor = NAVIGATION_COLOR;
    submitButton.layer.cornerRadius = 4;
    submitButton.layer.masksToBounds = YES;
    [submitButton setTitle:@"提 交" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:0.2];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-40);
        make.height.mas_equalTo(44);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(submitButton.mas_top).offset(-10);
    }];
    
    [self.tableView reloadData];
    
}
#pragma mark --- tableViewDelegate -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ?4:1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ?44:UITableViewAutomaticDimension;;
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ?44:88;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        TBTemplateInfoTableViewCell *cell_info = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier_info];
        cell_info.textField.userInteractionEnabled = indexPath.row == 0?NO:YES;
        cell_info.lefLabel.text = self.lefNameArray[indexPath.row];
        cell_info.textField.placeholder = self.ritNameArray[indexPath.row];
        
        cell = cell_info;
    }
    else if (indexPath.section == 1)
    {
        TBNoteTableViewCell *cell_label = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier_label];
        cell_label.textView.placeholder = @"门店暂停营业,搬迁等情况均可在此说明。";
        cell = cell_label;
    }
    else
    {
        static NSString *identifier = @"Identifier";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([indexPath isEqual:path] )
    {
        if (self.dataTool.shoptypes.count == 0)
        {
            hudShowInfo(@"数据正在加载");
            TBWeakSelf
            [TBBasicDataTool initializeTypeData:^(TBBasicDataTool *tool) {
                
                weakSelf.dataTool = tool;
            }];
        }
        else
        {
            ZKPickDataView *dataView = [[ZKPickDataView alloc] initData:self.dataTool.shoptypes typeName:@"商家类型" type:PickDataViewTypeMerchants];
            dataView.delegate = self;
            [dataView showSelectedData:self.shops.ID];
        }

    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark ---点击事件---
- (void)submitClick
{
    NSString * type = [self cellRitTextViewTextIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString * name = [self cellRitTextViewTextIndex:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString * address = [self cellRitTextViewTextIndex:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString * telphone = [self cellRitTextViewTextIndex:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    if (type.length == 0)
    {
        hudShowInfo(@"类型纠错必填!");
        return;
    }
    if (name.length == 0)
    {
        hudShowError(@"名称必填！");
        return;
    }
    if (telphone.length >0)
    {
        if (![ZKUtil checkNumber:telphone]) {
            hudShowError(@"请输入正确的电话");
            return;
        }
    }
    
    TBNoteTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSMutableDictionary *dic = [NSMutableDictionary params];
    dic[@"interfaceId"] = @"177";
    dic[@"did"] = [NSNumber numberWithInteger:self.shops.ID];
    dic[@"name"] = name;
    dic[@"address"] = address;
    dic[@"telphone"] = telphone;
    dic[@"info"] = cell.textView.text;
    dic[@"pid"] = [NSNumber numberWithInteger:self.errorData.ID];
    dic[@"uid"] = [UserInfo account].userID;
    
    [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
        
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        if ([errcode isEqualToString:@"00000"])
        {
            hudShowSuccess([responseObj valueForKey:@"errmsg"]);
            if (self.updata) {
                self.updata();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            hudShowError([responseObj valueForKey:@"errmsg"]);
        }
        
    } failure:^(NSError *error) {
        hudShowFailure();
    }];
}

// 取值
- (NSString*)cellRitTextViewTextIndex:(NSIndexPath*)path
{
    TBTemplateInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    return  cell.textField.text;
}

#pragma mark ---- ZKPickDataViewDelegate ---
- (void)selectedData:(TBBasicDataShoptypes*)shop;
{
    TBTemplateInfoTableViewCell *cell = [self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.textField.text = shop.name;
    self.shops = shop;
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
