//
//  TBPovertyAlleviationView.m
//  Telecom
//
//  Created by 王小腊 on 2017/5/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBPovertyAlleviationView.h"
#import "TBPovertyAlleviationTableViewCell.h"
#import "TBInServiceAreaView.h"
#import "TBIdentityInformationTableViewCell.h"
#import "TBMoreReminderView.h"
@interface TBPovertyAlleviationView()<UITableViewDelegate,UITableViewDataSource,IdentityInformationTableViewCelldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat photosHeight;

@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, strong) NSMutableDictionary *infoDictionary;

@property (nonatomic, assign) NSInteger employeesTotal;

@property (nonatomic, strong) NSArray *baseData;

@property (nonatomic, strong) NSIndexPath *photoIndex;
@end
@implementation TBPovertyAlleviationView

- (NSMutableDictionary *)infoDictionary
{
    if (!_infoDictionary)
    {
        _infoDictionary = [NSMutableDictionary dictionary];
        [_infoDictionary setValue:@"0" forKey:@"totalNum"];
        [_infoDictionary setValue:@"0" forKey:@"below20Num"];
        [_infoDictionary setValue:@"0" forKey:@"below35Num"];
        [_infoDictionary setValue:@"0" forKey:@"below50Num"];
        [_infoDictionary setValue:@"0" forKey:@"below65Num"];
        [_infoDictionary setValue:@"0" forKey:@"above65Num"];
        [_infoDictionary setValue:@"0" forKey:@"menNum"];
        [_infoDictionary setValue:@"0" forKey:@"womanNum"];
        [_infoDictionary setValue:@"0" forKey:@"lowSalary"];
        [_infoDictionary setValue:@"0" forKey:@"highSalary"];
    }
    return _infoDictionary;
}
- (NSArray *)baseData
{
    if (!_baseData)
    {
        _baseData = [NSArray arrayWithObjects:
                     @[@{@"name":@"35岁以下员工人数",@"state":@"选填"},
                       @{@"name":@"36-65岁员工人数",@"state":@"选填"},
                       @{@"name":@"65岁以上员工人数",@"state":@"选填"}],
                     @[@{@"name":@"薪资月收入最低",@"state":@"必填"},
                       @{@"name":@"薪资月收入最高",@"state":@"必填"}],
                     @[@{@"name":@"男性员工人数",@"state":@"选填"},
                       @{@"name":@"女性员工人数",@"state":@"选填"},
                       @{@"name":@"就业员工总人数",@"state":@""}
                       ],nil];
    }
    return _baseData;
}
- (NSMutableArray *)photoArray
{
    if (!_photoArray)
    {
        _photoArray = [NSMutableArray array];
        
    }
    return _photoArray;
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
        [_tableView registerClass:[TBPovertyAlleviationTableViewCell class] forCellReuseIdentifier:TBPovertyAlleviationTableViewCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TBIdentityInformationTableViewCell class]) bundle:nil] forCellReuseIdentifier:TBIdentityInformationTableViewCellID];
        
    }
    return _tableView;
}
// 视图创建
- (void)createAview;
{
    self.photosHeight = _SCREEN_WIDTH*325/1080+30+40*2;
    
    self.employeesTotal = 0;
    [self.infoDictionary setValue:@"0" forKey:[self accessToKeyCellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    [self addSubview:self.tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 50)];
    footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@" 增加" forState:UIControlStateNormal];
    [addButton setTitleColor:NAVIGATION_COLOR forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [addButton setImage:[UIImage imageNamed:@"introduce_add"] forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor whiteColor];
    [addButton addTarget:self action:@selector(addEmployees) forControlEvents:UIControlEventTouchUpInside];
    addButton.layer.cornerRadius = 4;
    [footView addSubview:addButton];
    
    self.tableView.tableFooterView = footView;
    TBWeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView.mas_top);
        make.width.mas_equalTo(_SCREEN_WIDTH-20);
        make.centerX.equalTo(footView.mas_centerX);
        make.height.equalTo(@44);
    }];
}
#pragma mark --UITableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 3)
    {
        return self.photoArray.count;
    }
    else
    {
        NSArray *tatol = [self.baseData objectAtIndex:section];
        return tatol.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        return self.photosHeight;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 3) {
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
    if (section == 0 || section == 3)
    {
        TBInServiceAreaView *headerView = [[TBInServiceAreaView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 44)];
        headerView.backgroundColor = [UIColor whiteColor];
        [headerView headAssignment:section == 0 ?@"就业人员信息填写":@"贫困就业人员信息填写"];
        return headerView;
    }
    return [[UIView alloc] init];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 3)
    {
        TBIdentityInformationTableViewCell *identityCell = [tableView dequeueReusableCellWithIdentifier:TBIdentityInformationTableViewCellID];
        identityCell.indexRow = indexPath.row;
        identityCell.delegate = self;
        if (self.photoArray.count >0)
        {
            [identityCell assignmentPhotos:[self.photoArray objectAtIndex:indexPath.row]];
        }
        cell = identityCell;
    }
    else
    {
        TBPovertyAlleviationTableViewCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:TBPovertyAlleviationTableViewCellID];
        NSDictionary *dic = [[self.baseData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [textFieldCell textLefName:[dic valueForKey:@"name"] rightName:[dic valueForKey:@"state"]];
        
        if (self.infoDictionary.count >0)
        {
            NSString *name = [self accessToKeyCellForRowAtIndexPath:indexPath];
            [textFieldCell assignmentTextFieldText:[self.infoDictionary valueForKey:name]];
        }
        [textFieldCell textFiledIsEditor:![indexPath isEqual:[NSIndexPath indexPathForRow:2 inSection:2]]];
        TBWeakSelf
        [textFieldCell textFieldEditEnd:^(NSString *name) {
            
            [weakSelf textFieldEditEnd:name cellForRowAtIndexPath:indexPath];
        }];
        cell = textFieldCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}
#pragma mark  ----逻辑处理----
- (void)textFieldEditEnd:(NSString *)name cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self accessToKeyCellForRowAtIndexPath:indexPath];
    [self.infoDictionary setValue:name forKey:key];
    
    if (indexPath.section == 2)
    {
        TBPovertyAlleviationTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
        
        NSInteger menNum = [[self.infoDictionary valueForKey:[self accessToKeyCellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]]] integerValue];
        NSInteger womanNum = [[self.infoDictionary valueForKey:[self accessToKeyCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]]] integerValue];
        NSString *numString = [NSString stringWithFormat:@"%ld",menNum+womanNum];
        
        [cell assignmentTextFieldText:numString];
        [self.infoDictionary setValue:numString forKey:[self accessToKeyCellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]]];
        // 更加数据获取真实总人数
        self.employeesTotal = menNum+womanNum;
    }
    
}
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
#pragma mark ---IdentityInformationTableViewCelldDelegate--

/**
 修改后的字典
 
 @param dictionary 字典
 @param row 第几个
 */
- (void)modifiedData:(NSDictionary *)dictionary indexRow:(NSInteger)row;
{
    [self.photoArray replaceObjectAtIndex:row withObject:dictionary];
}
/**
 删除员工信息
 
 @param row 第几个
 */
- (void)deleteEmployeeInformationIndex:(NSInteger)row;
{
    [self.photoArray removeObjectAtIndex:row];
    [self.tableView reloadData];
}

#pragma mark  --界面赋值--
/**
 数据更新
 
 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;
{
    self.makingList = makingList;
    if ([makingList.povertyInfoDic isKindOfClass:[NSDictionary class]])
    {
        [self.infoDictionary addEntriesFromDictionary:makingList.povertyInfoDic];
    }
    self.employeesTotal = [[self.infoDictionary valueForKey:@"totalNum"] integerValue];
    TBWeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [makingList.povertyPhotoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[NSString class]])
            {
                NSString *data = obj;
                if (data.length >200)
                {
                    NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:obj options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
                    if (_decodedImage)
                    {
                        [makingList.povertyPhotoArray replaceObjectAtIndex:idx withObject:_decodedImage];
                    }
                    else
                    {
                        [makingList.povertyPhotoArray removeObjectAtIndex:idx];
                    }
                }
            }
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.photoArray = weakSelf.makingList.povertyPhotoArray;
            [weakSelf reloadTableView];
        });
    });
    
    [self.tableView reloadData];
    
    NSString *code = [UserInfo account].code;
    NSString *pName;
    if ([code isEqualToString:JR_CODE] || [code isEqualToString:GZ_CODE])
    {
        pName = @"";
    }
    else
    {
        pName = @"(必填)";
    }
    return @{@"name":@"精准扶贫",@"prompt":pName};
}
#pragma mark -- button点击事件
// 添加贫困员工
- (void)addEmployees
{
    if (self.photoArray.count >0)
    {
        NSString *meg = [self verifyTheEmployeeInformation:self.photoArray.lastObject];
        if (meg.length>0)
        {
            [UIView addMJNotifierWithText:meg dismissAutomatically:YES];
            return;
        }
    }
    [self.photoArray addObject:@{yg_name:@"",yg_positive:@"",yg_reverse:@""}];
    [self.tableView reloadData];
    
    if (self.photoArray.count > 0) {
        [self.tableView scrollToRowAtIndexPath:
         [NSIndexPath indexPathForRow:[self.photoArray count]-1 inSection:3]
                              atScrollPosition: UITableViewScrollPositionBottom animated:NO];
    }
    
    
}
#pragma mark  --数据处理---
/**
 震动动画
 
 @param indexPath 第几个cell
 */
- (void)shakeAnimationForViewIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [ZKUtil shakeAnimationForView:cell.contentView];
}
/**
 数据提交
 
 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;
{
    __block  NSString *message = @"";
    TBWeakSelf
    [self.photoArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         message =  [weakSelf verifyTheEmployeeInformation:obj];
         if (message.length >0)
         {
             weakSelf.infoDictionary[@"indexPath"] = [NSIndexPath indexPathForRow:idx inSection:3];
         }
     }];
    
    [self.infoDictionary setValue:@"0" forKey:@"below20Num"];
    [self.infoDictionary setValue:@"0" forKey:@"below50Num"];
    
    self.makingList.povertyPhotoArray = self.photoArray;
    self.makingList.povertyInfoDic = self.infoDictionary;
    
    
    NSInteger salaryMax = [[self.infoDictionary valueForKey:[self accessToKeyCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]]] integerValue];
    NSInteger salaryMin = [[self.infoDictionary valueForKey:[self accessToKeyCellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]] integerValue];
    
    if (self.employeesTotal == 0)
    {
        message = @"员工人数不能都为0";
        self.infoDictionary[@"indexPath"] = [NSIndexPath indexPathForRow:0 inSection:2];
    }
    // 最大数小于了最小数
    if (salaryMax <salaryMin)
    {
        message = @"最高月收入小于最低月收入！";
        self.infoDictionary[@"indexPath"] = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    if (salaryMin == 0 )
    {
        message = @"薪资收入必填！";
        self.infoDictionary[@"indexPath"] = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    if (salaryMax == 0)
    {
        message = @"薪资收入必填！";
        self.infoDictionary[@"indexPath"] = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    
    NSString *code = [UserInfo account].code;
    if (self.makingList.modelsID == 5 || [code isEqualToString:GZ_CODE])
    {
        message = @"";
    }

    if (message.length >0 && prompt == YES)
    {
        NSIndexPath *indexPath = self.infoDictionary[@"indexPath"];
        [self shakeAnimationForViewIndexPath:indexPath];
        [UIView addMJNotifierWithText:message dismissAutomatically:YES];
    }
    
    [self.infoDictionary removeObjectForKey:@"indexPath"];
    return message.length == 0;
}


- (NSString *)verifyTheEmployeeInformation:(NSDictionary *)dic
{
    NSString *meg = @"";
    id positive = [dic valueForKey:yg_positive];
    id reverse = [dic valueForKey:yg_reverse];
    
    if (![reverse isKindOfClass:[UIImage class]])
    {
        NSString *reverseString = reverse;
        if (reverseString.length == 0)
        {
            meg = @"身份证反面照未上传！";
        }
    }
    
    if (![positive isKindOfClass:[UIImage class]])
    {
        NSString *positiveString = positive;
        if (positiveString.length == 0)
        {
            meg = @"身份证正面照未上传！";
        }
    }
    
    return meg;
}

- (void)reloadTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}
@end
