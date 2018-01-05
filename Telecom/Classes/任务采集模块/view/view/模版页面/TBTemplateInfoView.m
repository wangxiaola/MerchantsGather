//
//  TBTemplateInfoView.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTemplateInfoView.h"
#import "TBTemplateLabelTableViewCell.h"
#import "TBTemplateInfoTableViewCell.h"
#import "ZKNavigationController.h"
#import "TBBusinessesLocateViewController.h"
#import "TBRegionChooseView.h"
#import "TBBasicDataTool.h"
#import "TBMoreReminderView.h"
#import "ZKLocation.h"
#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]

@interface TBTemplateInfoView ()<UITableViewDelegate,UITableViewDataSource,TBRegionChooseViewDelegate,ZKLocationDelegate>

@property (nonatomic, strong) NSString *mes;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *lefNameArray;

@property (nonatomic, strong) NSArray *ritNameArray;

@property (nonatomic, assign ) double  latitude;

@property (nonatomic, assign ) double  longitude;

@property (nonatomic, strong) TBBasicDataTool *dataTool;

@property (nonatomic, strong) TBBasicDataTool *areaData;

@property (nonatomic, assign) NSInteger shopsID;// 类型数据

@property (nonatomic, strong) NSString *areasCode;// 区域代码

@property (nonatomic, strong) NSArray *labelsArray;

@property (nonatomic, strong) NSArray *rangesArray;

@property (nonatomic, strong) NSArray *suitablesArray;

@property (nonatomic, strong) NSMutableArray *cellArray;
//保存名称
@property (nonatomic, strong) NSString *shName;

@property (nonatomic, strong) TBTemplateLabelTableViewCell *rangCell;

@property (nonatomic, strong) TBTemplateLabelTableViewCell *labelsCell;

@property (nonatomic, strong) TBTemplateLabelTableViewCell *suitablesCell;
@property (nonatomic, strong) ZKLocation *location;

@property (nonatomic) ChooseViewComponent selectedComponent;
@end
@implementation TBTemplateInfoView

static NSString*const  reuseIdentifier_info = @"cell_info";
static NSString*const  reuseIdentifier_label = @"cell_label";

- (NSMutableArray *)cellArray
{
    
    if (!_cellArray)
    {
        _cellArray = [NSMutableArray array];
    }
    
    return _cellArray;
}
- (UITableView *)tableView
{
    
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 44;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableView;
}
- (TBBasicDataTool *)dataTool
{
    if (!_dataTool)
    {
        _dataTool = [[TBBasicDataTool alloc] init];
    }
    return _dataTool;
}
- (instancetype)init
{
    
    self = [super init];
    
    if (self)
    {
        [self.contenView addSubview:self.tableView];
        TBWeakSelf
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contenView);
            
        }];
        
        [self.tableView registerNib:[UINib nibWithNibName:@"TBTemplateInfoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_info];
        [self.tableView registerNib:[UINib nibWithNibName:@"TBTemplateLabelTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_label];
        
        for (int i = 0; i<8; i++) {
            
            TBTemplateInfoTableViewCell *cell_info = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_info];
            [self.cellArray addObject:cell_info];
        }
        self.lefNameArray = @[@"商家名称",@"商家类型",@"所属区域",@"GPS地址",@"详细地址",@"人均消费",@"联系电话",@"绑定手机号"];
        self.ritNameArray = @[@"商家名称",@"请选择商家类型",@"请选择所属区域地址",@"请定位您的GPS地址",@"请输入商家详细地址",@"请输入人均消费金额",@"对外展示的电话",@"请输入店铺老板手机号"];
        [self.tableView reloadData];
        
        self.rangCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_label];
        
        self.labelsCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_label];
        
        self.suitablesCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_label];
        
        [self.rangCell.tagsView setCompletionOriginal:^(NSArray *originalArray){
            weakSelf.rangesArray = originalArray;
        }];
        
        [self.labelsCell.tagsView setCompletionOriginal:^(NSArray *originalArray){
            weakSelf.labelsArray = originalArray;
        }];
        
        [self.suitablesCell.tagsView setCompletionOriginal:^(NSArray *originalArray){
            weakSelf.suitablesArray = originalArray;
        }];
        [TBBasicDataTool initRegionData:^(TBBasicDataTool *tool) {
            
            weakSelf.areaData = tool;
        }];
        
        self.location = [[ZKLocation alloc] init];
        self.location.delegate = self;
        [self.location beginUpdatingLocation];
    }
    
    return self;
    
}
#pragma mark --- tableViewDelegate -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataTool.labels.count == 0 && self.dataTool.suitables.count == 0 && self.dataTool.grades.count == 0)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.lefNameArray.count;
    }
    else
    {
        if (self.dataTool.suitables.count == 0 && self.dataTool.grades.count == 0)
        {
            return 2;
        }
        else if (self.dataTool.suitables.count == 0 && self.dataTool.grades.count == 0 && self.dataTool.areas.data.count == 0)
        {
            
            return 1;
        }
        else
        {
            return 3;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 44;
    }
    else if (indexPath.section == 1)
    {
        
        if (indexPath.row == 0 && self.dataTool.ranges.count == 0)
        {
            return 0.01f;
        }
        else  if (indexPath.row == 1 && self.dataTool.labels.count == 0)
        {
            return 0.01f;
        }
        else
        {
            return UITableViewAutomaticDimension;
        }
    }
    else
    {
        return 0.01f;
    }
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
    
    if (indexPath.section == 0&&self.cellArray.count == 8)
    {
        TBTemplateInfoTableViewCell *cell_info = [self.cellArray objectAtIndex:indexPath.row];
        
        cell_info.lefLabel.text = self.lefNameArray[indexPath.row];
        cell_info.textField.placeholder = self.ritNameArray[indexPath.row];
        
        cell_info.textField.userInteractionEnabled = indexPath.row>3?YES:NO;
        if (indexPath.row == 0)
        {
            cell_info.textField.userInteractionEnabled = YES;
        }
        if (indexPath.row == 6 || indexPath.row == 7) {
            cell_info.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        else if (indexPath.row == 5)
        {
            cell_info.textField.keyboardType = UIKeyboardTypeDecimalPad;
        }
        else
        {
            cell_info.textField.keyboardType = UIKeyboardTypeDefault;
        }
        cell = cell_info;
    }
    else if(indexPath.section == 1)
    {
        
        if (indexPath.row == 0)
        {
            cell = self.rangCell;
            
        }
        else if (indexPath.row == 1 && self.dataTool.labels.count>0)
        {
            cell = self.labelsCell;
            
        }
        else if (indexPath.row == 2)
        {
            cell = self.suitablesCell;
            
        }
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
    [self endEditing:YES];
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:2 inSection:0]])
    {//  所属区域
        [self selectArea];
    }
    else if ([indexPath isEqual:[NSIndexPath indexPathForRow:3 inSection:0]])
    {// GPS地址
        
        TBBusinessesLocateViewController *mapVC = [[TBBusinessesLocateViewController alloc] init];
        if (self.latitude>0&&self.longitude>0)
        {
            mapVC.latitude = self.latitude;
            mapVC.longitude = self.longitude;
        }
        
        ZKNavigationController *nav = [[ZKNavigationController alloc] initWithRootViewController:mapVC];
        [[ZKUtil getPresentedViewController] presentViewController:nav animated:YES completion:^{
        }];
        
        TBWeakSelf
        [mapVC setUserLocation:^(NSString *address, double lat, double lon) {
            [weakSelf updataLocationAddress:address lat:lat lon:lon];
        }];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

#pragma mark ---- TBRegionChooseViewDelegate ---

- (void)selectedRegionName:(NSString *)name RegionCode:(NSString *)code;
{
    [self cellRitTextViewText:name index:2];
    self.areasCode = code;
}
- (void)selectedProvincesComponent:(ChooseViewComponent)chooseViewComponent;
{
    self.selectedComponent = chooseViewComponent;
}
#pragma mark  ----ZKLocationDelegate----
- (void)locationDidEndUpdatingLocation:(Location *)location;
{
    NSString *address = [self cellRitTextViewTextIndex:3];
    if (address.length == 0)
    {
        [self updataLocationAddress:location.formattedAddress lat:location.latitude lon:location.longitude];
    }
    
}

#pragma mark --- 更新标签 ---
- (void)updataCellTagsType:(NSString *)type;
{
    MJWeakSelf
    [self.dataTool requestDataTypes:type dataTool:^(TBBasicDataTool *tool)
     {
         weakSelf.dataTool = tool;
         [self updataCellLabels];
         [weakSelf.tableView reloadData];
     }];
}
- (void)updataCellLabels
{
    [self.rangCell updataTags:self.rangesArray TitisArray:self.dataTool.ranges];
    [self.labelsCell updataTags:self.labelsArray TitisArray:self.dataTool.labels];
    if (self.dataTool.suitables.count == 0)
    {   // 等级
        
        [self.suitablesCell updataTags:self.suitablesArray TitisArray:self.dataTool.grades];
    }
    else
    { // 合适
        [self.suitablesCell updataTags:self.suitablesArray TitisArray:self.dataTool.suitables];
    }
}
/**
 更新地址
 
 @param address 地址
 @param lat lat
 @param lon lon
 */
- (void)updataLocationAddress:(NSString *)address lat:(double)lat lon:(double)lon
{
    self.latitude = lat;
    self.longitude = lon;
    NSString *add = [NSString stringWithFormat:@"N%.4f E%.4f",self.latitude,self.longitude];
    [self cellRitTextViewText:add index:3];
    [self cellRitTextViewText:address index:4];
}
/**
 选择区域
 */
- (void)selectArea
{
    if (self.areaData.areas.data.count == 0)
    {
        hudShowError(@"数据正在加载中...");
        TBWeakSelf
        
        [TBBasicDataTool initRegionData:^(TBBasicDataTool *tool) {
            weakSelf.areaData = tool;
        }];
    }
    else
    {
        
        TBRegionChooseView *dataView = [[TBRegionChooseView alloc] initRegionData:self.areaData.areas];
        dataView.delegate = self;
        [dataView showSelectedRegionComponent:self.selectedComponent];
    }
    
}

#pragma mark ----
// 赋值
- (void)cellRitTextViewText:(NSString*)str index:(NSInteger)row
{
    if (row<self.cellArray.count&&![str isKindOfClass:[NSNull class]]&&str!=nil)
    {
        TBTemplateInfoTableViewCell *cell = [self.cellArray objectAtIndex:row];
        cell.textField.text = [NSString stringWithFormat:@"%@",str];
    }
}
// 取值
- (NSString*)cellRitTextViewTextIndex:(NSInteger)row
{
    if (row>=self.cellArray.count){return @"";}
    TBTemplateInfoTableViewCell *cell = [self.cellArray objectAtIndex:row];
    return  cell.textField.text;
}

/**
 震动动画
 
 @param indexPath 第几个cell
 */
- (void)shakeAnimationForViewIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    
    TBTemplateInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [ZKUtil shakeAnimationForView:cell.contentView];
}
#pragma mark --外部赋值--
/**
 数据更新
 
 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;
{
    self.makingList = makingList;
    self.areasCode = @"";
    NSDictionary *m1 = makingList.infoDic;
    
    TBWeakSelf
    self.shopsID = [[m1 valueForKey:@"type"] integerValue];
    
    NSString *areasCode = [m1 valueForKey:@"code"];
    if ([areasCode isKindOfClass:[NSNull class]])
    {
        areasCode = @"";
    }
    
    [self updataCellShoptypesID:self.shopsID];
    
    if (self.areaData.areas.data.count > 0)
    {
        [self updataCellAreasID:areasCode];
    }
    else
    {
        [TBBasicDataTool initRegionData:^(TBBasicDataTool *tool) {
            weakSelf.areaData = tool;
            [weakSelf updataCellAreasID:areasCode];
        }];
    }
    
    self.shName  = [m1 valueForKey:@"name"];
    
    if (self.shName.length>0)
    {
        [self cellRitTextViewText:self.shName index:0];
    }
    
    NSString *lat = [m1 valueForKey:@"lat"];
    NSString *lng = [m1 valueForKey:@"lng"];
    
    if (![lat isKindOfClass:[NSNull class]] || ![lng isKindOfClass:[NSNull class]])
    {
        self.latitude = [lat doubleValue];
        self.longitude = [lng doubleValue];
        if (self.latitude != 0||self.longitude != 0)
        {
            NSString *add = [NSString stringWithFormat:@"N%.4f E%.4f",self.latitude,self.longitude];
            [self cellRitTextViewText:add index:3];
        }
        
    }
    
    [self cellRitTextViewText:[m1 valueForKey:@"address"] index:4];
    [self cellRitTextViewText:[m1 valueForKey:@"percost"] index:5];
    [self cellRitTextViewText:[m1 valueForKey:@"phone"] index:7];
    [self cellRitTextViewText:[m1 valueForKey:@"tel"] index:6];
    
    
    NSString *labels = [m1 valueForKey:@"label"];
    NSString *suitables = [m1 valueForKey:@"suitable"];
    NSString *ranges = [m1 valueForKey:@"range"];
    
    
    if (![labels isKindOfClass:[NSNull class]])
    {
        self.labelsArray = [labels componentsSeparatedByString:@","];
    }
    if (![suitables isKindOfClass:[NSNull class]]) {
        
        self.suitablesArray = [suitables componentsSeparatedByString:@","];
    }
    if (![ranges isKindOfClass:[NSNull class]])
    {
        self.rangesArray = [ranges componentsSeparatedByString:@","];
    }
    [self.tableView reloadData];
    [self updataCellLabels];
    
    return @{@"name":@"基本信息",@"prompt":@"(必填)"};
}

- (void)updataCellShoptypesID:(NSInteger)code;
{
    TBWeakSelf
    NSArray *arr = [TBBasicDataTool businessType];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger typeID = [[obj valueForKey:@"ID"] integerValue];
        if (typeID == self.shopsID)
        {
            [weakSelf cellRitTextViewText:[obj valueForKey:@"name"] index:1];
            [weakSelf updataCellTagsType:[obj valueForKey:@"type"]];
        }
        
    }];
    
}
- (void)updataCellAreasID:(NSString *)code
{
    TBWeakSelf
    if (code.length > 0)
    {
        [self.areaData.areas.data enumerateObjectsUsingBlock:^(TBRegionData * _Nonnull dataObj, NSUInteger dataIdx, BOOL * _Nonnull dataStop)
         {
             *dataStop = [weakSelf regionalValidationCode:code regCode:dataObj.code regName:dataObj.name component:ChooseViewComponentMake(dataIdx, 0, 0)];
             
             [dataObj.children enumerateObjectsUsingBlock:^(TBRegionCityChildren * _Nonnull cityChildrenObj, NSUInteger cityChildrenIdx, BOOL * _Nonnull cityChildrenStop) {
                 
                 *cityChildrenStop = [weakSelf regionalValidationCode:code regCode:cityChildrenObj.code regName:cityChildrenObj.name component:ChooseViewComponentMake(dataIdx, cityChildrenIdx, 0)];
                 
                 [cityChildrenObj.children enumerateObjectsUsingBlock:^(TBRegionAreaChildren * _Nonnull areaChildrenObj, NSUInteger areaChildrenIdx, BOOL * _Nonnull areaChildrenStop) {
                     
                     *areaChildrenStop = [weakSelf regionalValidationCode:code regCode:areaChildrenObj.code regName:areaChildrenObj.name component:ChooseViewComponentMake(dataIdx, cityChildrenIdx, areaChildrenIdx)];
                 }];
                 
             }];
             
         }];
        
    }
    
}

/**
 判断是否code一样
 
 @param validationCode 验证基本
 @param regCode 要验证的code
 @param name 要验证的地区名称
 @param component 坐标
 @return 是否一样
 */
- (BOOL)regionalValidationCode:(NSString *)validationCode regCode:(NSString *)regCode regName:(NSString *)name component:(ChooseViewComponent)component;
{
    if (validationCode.integerValue == regCode.integerValue)
    {
        self.selectedComponent = component;
        [self cellRitTextViewText:name index:2];
        self.areasCode = regCode;
        return YES;
    }
    return NO;
}
#pragma mark ---外部取值--

// 验证名称是否修改过
- (BOOL)isNameEditor;
{
    NSString *name = [self cellRitTextViewTextIndex:0];
    return ![self.shName isEqualToString:name];
    
}
/**
 数据提交
 
 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;
{
    self.mes = @"";
    if (self.dataTool.suitables.count == 0&&self.dataTool.labels.count == 0)
    {
        self.mes = @"数据还未加载完";
        [self updataCellShoptypesID:self.shopsID];
    }
    NSMutableDictionary *dic = [self extractingData];
    self.makingList.msg = self.mes;
    
    if (self.makingList.msg.length == 0 )
    {
        [dic removeObjectForKey:@"indexPath"];
        self.makingList.infoDic = dic.copy;
        return YES;
    }
    else
    {
        if (prompt == YES) {
            [UIView addMJNotifierWithText:self.makingList.msg dismissAutomatically:YES];
            NSIndexPath *indexPath = self.makingList.infoDic[@"indexPath"];
            [self shakeAnimationForViewIndexPath:indexPath];
        }
        [dic removeObjectForKey:@"indexPath"];
        self.makingList.infoDic = dic.copy;
        return NO;
    }
}

- (NSMutableDictionary *)extractingData;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *name = [self cellRitTextViewTextIndex:0];
    NSString *type = [self cellRitTextViewTextIndex:1];
    NSString *qy = [self cellRitTextViewTextIndex:2];
    NSString *gps = [self cellRitTextViewTextIndex:3];
    NSString *address = [self cellRitTextViewTextIndex:4];
    NSString *xf = [self cellRitTextViewTextIndex:5];
    NSString *phone = [self cellRitTextViewTextIndex:7];
    NSString *tel = [self cellRitTextViewTextIndex:6];
    
    if (self.dataTool.grades.count>0)
    {
        if (self.suitablesArray.count == 0)
        {
            self.mes = @"请选择标签";
            dic[@"indexPath"] = [NSIndexPath indexPathForRow:2 inSection:1];
        }
        
    }
    if (self.dataTool.suitables.count>0)
    {
        if (self.suitablesArray.count == 0)
        {
            self.mes = @"请选择标签";
            dic[@"indexPath"] = [NSIndexPath indexPathForRow:2 inSection:1];
        }
        
    }
    if (self.dataTool.labels.count>0)
    {
        if (self.labelsArray.count == 0)
        {
            self.mes = @"请选择标签";
            dic[@"indexPath"] = [NSIndexPath indexPathForRow:1 inSection:1];
        }
        
    }
    if (self.dataTool.ranges.count > 0) {
        if (self.rangesArray.count == 0)
        {
            self.mes = @"请选择标签";
            dic[@"indexPath"] = [NSIndexPath indexPathForRow:0 inSection:1];
        }
        
    }
    
    
    if (![ZKUtil isMobileNumber:phone])
    {
        [self cellRitTextViewText:@"" index:7];
        self.mes = @"绑定手机号码有误！";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:7 inSection:0];
    }
    else if ([phone isEqualToString:[UserInfo account].phone])
    {
        self.mes = @"绑定手机号码不能是网格经理的";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:7 inSection:0];
        
    }
    
    if (![ZKUtil checkNumber:tel])
    {
        [self cellRitTextViewText:@"" index:6];
        self.mes = @"联系电话填写有误！";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:6 inSection:0];
    }
    
    if (![ZKUtil ismoney:xf]) {
        
        [self cellRitTextViewText:@"" index:5];
        self.mes = @"人均消费格式不对!";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:5 inSection:0];
    }
    
    if (address.length == 0)
    {
        self.mes = @"请填写详细地址!";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:4 inSection:0];
    }
    if (gps.length == 0)
    {
        self.mes = @"请先定位!";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:3 inSection:0];
    }
    
    if (qy.length == 0)
    {
        self.mes = @"请选择区域类型!";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:2 inSection:0];
    }
    
    if (type.length == 0)
    {
        self.mes = @"请选择商家类型!";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    
    if (name.length == 0)
    {
        self.mes = @"请填写商家名称!";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [dic setObject:address forKey:@"address"];
    if (self.areasCode == nil)
    {
        self.areasCode = @"";
    }
    [dic setObject:self.areasCode forKey:@"code"];
    
    if (self.labelsArray.count >0)
    {
        [dic setObject:[self.labelsArray componentsJoinedByString:@","] forKey:@"label"];
    }
    if (self.suitablesArray.count >0)
    {
        [dic setObject:[self.suitablesArray componentsJoinedByString:@","] forKey:@"suitable"];
    }
    if (self.rangesArray.count >0)
    {
        [dic setObject:[self.rangesArray componentsJoinedByString:@","] forKey:@"range"];
    }
    
    
    NSString *lat = [NSString stringWithFormat:@"%.6f",self.latitude];
    NSString *lon = [NSString stringWithFormat:@"%.6f",self.longitude];
    [dic setObject:lat forKey:@"lat"];
    [dic setObject:lon forKey:@"lng"];
    [dic setObject:name forKey:@"name"];
    [dic setObject:xf forKey:@"percost"];
    [dic setObject:phone forKey:@"phone"];
    [dic setObject:tel forKey:@"tel"];
    [dic setObject:type forKey:@"taskType"];
    [dic setObject:[NSNumber numberWithInteger:self.shopsID] forKey:@"type"];
    
    return dic;
}

@end
