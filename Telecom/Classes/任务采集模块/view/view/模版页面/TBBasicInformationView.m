//
//  TBBasicInformationView.m
//  Telecom
//
//  Created by 王小腊 on 2017/5/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBasicInformationView.h"
#import "TBBusinessIntelligencePhotoTableViewCell.h"
#import "TBTemplateInfoTableViewCell.h"
#import "TBBusinessServiceTableViewCell.h"
#import "TBBusinessIntelligenceTableViewCell.h"
#import "TBNoteTableViewCell.h"
#import "TBBusinessesLocateViewController.h"
#import "ZKNavigationController.h"
#import "TBBasicServicetypeMode.h"
#import "TBBusinessIntelligenceViewMode.h"
#import "UIImage+Thumbnail.h"
#import "TBRegionChooseView.h"
#import "TBBasicDataTool.h"
#import "TBMakingListMode.h"
#import "ZKLocation.h"

static NSString*const  reuseIdentifier_info = @"cell_info";
static NSString*const  reuseIdentifier_photo = @"cell_photo";
static NSString*const  reuseIdentifier_describe = @"cell_describe";

@interface TBBasicInformationView()<UITableViewDelegate,UITableViewDataSource,TBRegionChooseViewDelegate,ZKLocationDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *lefNameArray;

@property (nonatomic, strong) NSArray *ritNameArray;

@property (nonatomic, assign) double  latitude;

@property (nonatomic, assign) double  longitude;

@property (nonatomic, strong) TBBasicDataTool *areaData;

@property (nonatomic, strong) TBBasicServicetypeMode *modeList;

@property (nonatomic, strong) TBBusinessIntelligenceViewMode *labelMode;

@property (nonatomic, strong) NSString *rangeLabel;

@property (nonatomic, strong) NSString *servicelablesLabel;

@property (nonatomic, strong) NSMutableArray *cellArray;

@property (nonatomic, strong) TBBusinessServiceTableViewCell *serviceCell;

@property (nonatomic, strong) TBBusinessIntelligenceTableViewCell *cellLabel;
//照片cell
@property (nonatomic, strong) TBBusinessIntelligencePhotoTableViewCell *photoCell;

@property (nonatomic, strong) TBNoteTableViewCell *infoTextCell;

@property (nonatomic, strong) ZKLocation *location;

@property (nonatomic, strong) NSString *type;//服务场所

@property (nonatomic, strong) NSString *areasCode;// 区域代码

@property (nonatomic, assign) NSInteger typeID;//服务场所ID

@property (nonatomic) ChooseViewComponent selectedComponent;
@end
@implementation TBBasicInformationView
- (TBBusinessIntelligenceViewMode *)labelMode
{
    if (!_labelMode)
    {
        _labelMode = [[TBBusinessIntelligenceViewMode alloc] init];
    }
    return _labelMode;
}

- (NSMutableArray *)cellArray
{
    if (!_cellArray)
    {
        _cellArray = [NSMutableArray arrayWithCapacity:5];
    }
    
    return _cellArray;
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _tableView.tableFooterView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 0.01)];
        _tableView.tableHeaderView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 0.01)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [_tableView registerNib:[UINib nibWithNibName:@"TBTemplateInfoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_info];
        [_tableView registerNib:[UINib nibWithNibName:@"TBBusinessServiceTableViewCell" bundle:nil] forCellReuseIdentifier:TBBusinessServiceTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"TBBusinessIntelligencePhotoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_photo];
        [_tableView registerNib:[UINib nibWithNibName:@"TBBusinessIntelligenceTableViewCell" bundle:nil] forCellReuseIdentifier:TBBusinessIntelligenceTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"TBNoteTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_describe];
    }
    return _tableView;
}

- (void)createAview;
{
    [self viewTheConfiguration];
    [self initData];
    [self postLabels];
}
#pragma mark ---- 视图配置 ---
/**
 视图配置
 */
- (void)viewTheConfiguration
{
    [self addSubview:self.tableView];
    
    self.photoCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_photo];
    self.photoCell.maxRow = 9;
    
    self.serviceCell = [self.tableView dequeueReusableCellWithIdentifier:TBBusinessServiceTableViewCellID];
    
    self.cellLabel = [self.tableView dequeueReusableCellWithIdentifier:TBBusinessIntelligenceTableViewCellID];
    
    self.infoTextCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_describe];
    self.infoTextCell.textView.placeholder = @"请输入要描述的文字！";
    [self.infoTextCell.promptButton setTitle:@" 描述" forState:UIControlStateNormal];
    
    TBWeakSelf
    
    [self.serviceCell.tagsView setCompletionOriginal:^(NSArray *array) {
        
        if (array.count > 0)
        {
            weakSelf.rangeLabel = [NSString stringWithFormat:@"%@",array.firstObject];
        }
        else
        {
            weakSelf.rangeLabel = nil;
        }
    }];
    
    [self.serviceCell setUpdataTableView:^{
        [weakSelf tableViewReloadData];
    }];
    [self.cellLabel setUpdataTableView:^{
        
        [weakSelf tableViewReloadData];
    }];
    [self.cellLabel.tagsView setCompletionOriginal:^(NSArray *array) {
        
        if (array.count > 0)
        {
            weakSelf.servicelablesLabel = [NSString stringWithFormat:@"%@",array.firstObject];
        }
        else
        {
            weakSelf.servicelablesLabel = nil;
        }
        
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
}
- (void)initData
{
    
    self.type = @"service";
    self.typeID = 23;
    
    self.lefNameArray = @[@"商家类型",@"门店名称",@"所属区域",@"门店电话",@"GPS定位",@"门店地址",@"绑定手机号"];
    self.ritNameArray = @[@"",@"请输入",@"请选择",@"请输入",@"可手动纠正定位",@"请输入",@"请输入店铺老板手机号"];
    
    for (int i = 0; i<self.lefNameArray.count; i++) {
        
        TBTemplateInfoTableViewCell *cell_info = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_info];
        [self.cellArray addObject:cell_info];
    }
    
    
    TBWeakSelf
    [self.photoCell setUpdataTableView:^{
        
        [weakSelf tableViewReloadData];
    }];
    
    [TBBasicDataTool initRegionData:^(TBBasicDataTool *tool) {
        
        weakSelf.areaData = tool;
        [weakSelf updataCellType];
        
    }];
    
    [self cellRitTextViewText:@"服务场所" index:0];
    [self tableViewReloadData];
    
    self.location = [[ZKLocation alloc] init];
    self.location.delegate = self;
    [self.location beginUpdatingLocation];
    
}
- (void)postLabels
{
    TBWeakSelf;
    [self.labelMode postLabels];
    [self.labelMode setServicetypeMode:^(TBBasicServicetypeMode *mode) {
        
        weakSelf.modeList = mode;
        [weakSelf updataLabels];
    }];
    
}
#pragma mark ----外部传值----
/**
 数据更新
 
 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;
{
    if (makingList == nil)
    {
         return @{@"name":@"基本信息",@"prompt":@"(必填)"};
    }
    self.makingList = makingList;
    
    NSDictionary *m1 = makingList.infoDic;
    
    [self cellRitTextViewText:[m1 valueForKey:@"name"] index:1];
    [self cellRitTextViewText:[m1 valueForKey:@"address"] index:5];
    [self cellRitTextViewText:[m1 valueForKey:@"tel"] index:3];
    if (makingList.modelsID !=5 )
    {
        [self cellRitTextViewText:[m1 valueForKey:@"phone"] index:6];
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
            [self cellRitTextViewText:add index:4];
        }
    }
    
    NSString *desc = [m1 valueForKey:@"desc"];
    if (desc.length > 0)
    {
        self.infoTextCell.textView.text = desc;
    }
    self.rangeLabel = [m1 valueForKey:@"range"];
    self.servicelablesLabel = [m1 valueForKey:@"label"];
    self.areasCode = [m1 valueForKey:@"code"];
    [makingList.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[NSString class]])
        {
            NSString *data = obj;
            if (data.length >100)
            {
                NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:obj options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
                if (_decodedImage)
                {
                    [makingList.images replaceObjectAtIndex:idx withObject:_decodedImage];
                }
                else
                {
                    [makingList.images removeObjectAtIndex:idx];
                }
            }
        }
        
    }];
    
    self.photoCell.imageArray = self.makingList.images;
    [self.photoCell updataCollectionView];
    [self updataLabels];
    [self updataCellType];
    [self tableViewReloadData];
    return @{@"name":@"基本信息",@"prompt":@"(必填)"};
}
// 更新区域
- (void)updataCellType
{
    if (self.areasCode)
    {
        TBWeakSelf
        [self.areaData.areas.data enumerateObjectsUsingBlock:^(TBRegionData * _Nonnull dataObj, NSUInteger dataIdx, BOOL * _Nonnull dataStop)
         {
             *dataStop = [weakSelf regionalValidationRegCode:dataObj.code regName:dataObj.name component:ChooseViewComponentMake(dataIdx, 0, 0)];
             
             [dataObj.children enumerateObjectsUsingBlock:^(TBRegionCityChildren * _Nonnull cityChildrenObj, NSUInteger cityChildrenIdx, BOOL * _Nonnull cityChildrenStop) {
                 
                 *cityChildrenStop = [weakSelf regionalValidationRegCode:cityChildrenObj.code regName:cityChildrenObj.name component:ChooseViewComponentMake(dataIdx, cityChildrenIdx, 0)];
                 
                 [cityChildrenObj.children enumerateObjectsUsingBlock:^(TBRegionAreaChildren * _Nonnull areaChildrenObj, NSUInteger areaChildrenIdx, BOOL * _Nonnull areaChildrenStop) {
                     
                     *areaChildrenStop = [weakSelf regionalValidationRegCode:areaChildrenObj.code regName:areaChildrenObj.name component:ChooseViewComponentMake(dataIdx, cityChildrenIdx, areaChildrenIdx)];
                 }];
                 
             }];
             
         }];
        
    }
}
/**
 判断是否code一样
 
 @param regCode 要验证的code
 @param name 要验证的地区名称
 @return 是否一样
 */
- (BOOL)regionalValidationRegCode:(NSString *)regCode regName:(NSString *)name component:(ChooseViewComponent)component
{
    if (self.areasCode.integerValue == regCode.integerValue)
    {
        self.selectedComponent = component;
        [self cellRitTextViewText:name index:2];
        return YES;
    }
    return NO;
}
// 更新cell标签赋值
- (void)updataLabels
{
    [self.serviceCell updataCellLabels:self.modeList.range selectKey:self.rangeLabel];
    [self.cellLabel updataCellLabels:self.modeList.servicelables selectKey:self.servicelablesLabel];
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
    [self cellRitTextViewText:add index:4];
    [self cellRitTextViewText:address index:5];
}
- (void)tableViewReloadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

#pragma mark --- tableViewDelegate -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.makingList.modelsID == 5?self.lefNameArray.count - 1:self.lefNameArray.count;
    }
    else if (section == 1)
    {
        return self.modeList.range.count == 0?0:1;
    }
    else if (section == 2)
    {
        return self.modeList.servicelables.count == 0 ?0:1;
    }
    else
    {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 44;
    }
    else
    {
        return UITableViewAutomaticDimension;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2)
    {
        return 36;
    }
    else
    {
        return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 ||section == 3)
    {
        return 10;
    }
    else
    {
        if (section == 1)
        {
            return self.modeList.range.count == 0?0.01:10;
        }
        else
        {
            return self.modeList.servicelables.count == 0?0.01:10;
        }
    }
    return 0.01;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 0.01)];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 36)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, _SCREEN_WIDTH, headerView.frame.size.height)];
        nameLabel.text = section == 1?@"经营范围":@"选择标签";
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [UIColor blackColor];
        [headerView addSubview:nameLabel];
        
        return headerView;
    }
    else
    {
        return  [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 0.01)];
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        TBTemplateInfoTableViewCell *cell_info = [self.cellArray objectAtIndex:indexPath.row];
        cell_info.lefLabel.text = self.lefNameArray[indexPath.row];
        cell_info.textField.placeholder = self.ritNameArray[indexPath.row];
        if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 2)
        {
            cell_info.textField.userInteractionEnabled = NO;
        }
        else
        {
            cell_info.textField.userInteractionEnabled = YES;
        }
        if (indexPath.row == 3 || indexPath.row == 6) {
            cell_info.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        else
        {
            cell_info.textField.keyboardType = UIKeyboardTypeDefault;
        }
        
        cell = cell_info;
    }
    else if(indexPath.section == 1)
    {
        
        cell = self.serviceCell;
        
    }
    else if (indexPath.section == 2)
    {
        
        cell = self.cellLabel;
    }
    else if (indexPath.section == 3)
    {
        cell = self.photoCell;
    }
    else if (indexPath.section == 4)
    {
        cell = self.infoTextCell;
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
    {
        //  所属区域
        [self selectArea];
    }
    else if ([indexPath isEqual:[NSIndexPath indexPathForRow:4 inSection:0]])
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
/**
 选择区域
 */
- (void)selectArea
{
    if (self.areaData.areas.data.count == 0)
    {
        hudShowError(@"数据加载中...");
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

#pragma mark ---- tool ---
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
#pragma mark  ----ZKLocationDelegate----
- (void)locationDidEndUpdatingLocation:(Location *)location;
{
    NSString *address = [self cellRitTextViewTextIndex:4];
    if (address.length == 0)
    {
        [self updataLocationAddress:location.formattedAddress lat:location.latitude lon:location.longitude];
    }
    
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

#pragma mark  --数据处理---
/**
 数据提交
 
 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;
{
    NSString *message = @"";
    
    self.makingList.type = @"service";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:self.typeID] forKey:@"type"];
    [dic setObject:@"" forKey:@"phone"];
    [dic setObject:@"" forKey:@"tel"];
    
    self.makingList.images = self.photoCell.imageArray;
    
    if (self.makingList.images.count == 0)
    {
        message = @"请至少上传一张照片";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:0 inSection:3];
    }
    
    if (self.servicelablesLabel.length>0)
    {
        [dic setObject:self.servicelablesLabel forKey:@"label"];
    }
    else
    {
        message = @"请选择标签";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:0 inSection:2];
    }
    
    if (self.rangeLabel.length >0)
    {
        [dic setObject:self.rangeLabel forKey:@"range"];
    }
    else
    {
        message = @"请选择标签";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    
    NSString *name = [self cellRitTextViewTextIndex:1];
    NSString *codeName = [self cellRitTextViewTextIndex:2];
    NSString *address = [self cellRitTextViewTextIndex:5];
    NSString *telString = [self cellRitTextViewTextIndex:3];
    
    if (self.makingList.modelsID !=5)
    {
        NSString *phoneString = [self cellRitTextViewTextIndex:6];
        
        if ([ZKUtil isMobileNumber:phoneString])
        {
            [dic setObject:phoneString forKey:@"phone"];
            
            if ([phoneString isEqualToString:[UserInfo account].phone]) {
                
                message = @"绑定手机号码不能是网格经理的!";
                dic[@"indexPath"] = [NSIndexPath indexPathForRow:6 inSection:0];
            }
        }
        else
        {
            message = @"请输入正确的绑定手机号码!";
            dic[@"indexPath"] = [NSIndexPath indexPathForRow:6 inSection:0];
        }
        
    }
    
    if (address.length>0) {
        [dic setObject:address forKey:@"address"];
    }
    else
    {
        message = @"请填写地址";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:5 inSection:0];
    }
    
    if (self.latitude > 0&&self.longitude >0)
    {
        NSString *lat = [NSString stringWithFormat:@"%.6f",self.latitude];
        NSString *lon = [NSString stringWithFormat:@"%.6f",self.longitude];
        [dic setObject:lat forKey:@"lat"];
        [dic setObject:lon forKey:@"lng"];
    }
    else
    {
        message = @"请定位当前位置";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:4 inSection:0];
    }
    
    if ([ZKUtil checkNumber:telString])
    {
        [dic setObject:telString forKey:@"tel"];
    }
    else if (self.makingList.modelsID !=5)
    {
        message = @"请输入正确的联系电话";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:3 inSection:0];
    }
    
    if (codeName.length == 0)
    {
        message = @"请选择所属区域";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:2 inSection:0];
    }
    else
    {
        [dic setObject:self.areasCode forKey:@"code"];
    }
    if (name.length >0)
    {
        [dic setObject:name forKey:@"name"];
    }
    else
    {
        message = @"请填写名称";
        dic[@"indexPath"] = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    
    [dic setObject:@"0" forKey:@"percost"];
    [dic setObject:@"" forKey:@"info"];
    [dic setObject:@"" forKey:@"suitable"];
    [dic setObject:self.infoTextCell.textView.text forKey:@"desc"];
    
    if (self.makingList.saveID.length == 0)
    {
        self.makingList.saveID = [ZKUtil timeStamp];
    }
    self.makingList.complete = message.length == 0?1:0;
    self.makingList.infoDic = dic.copy;
    
    self.makingList.msg = message;
    
    NSIndexPath *indexPath = dic[@"indexPath"];
    
    if (self.makingList.msg.length == 0 )
    {
        [dic removeObjectForKey:@"indexPath"];
        return YES;
    }
    else
    {
        if (prompt == YES) {
            [UIView addMJNotifierWithText:self.makingList.msg dismissAutomatically:YES];
            [self shakeAnimationForViewIndexPath:indexPath];
        }
        [dic removeObjectForKey:@"indexPath"];
        return NO;
    }
}


/**
 验证对象合法性
 
 @param str str
 @param msg msg
 @return bool
 */
- (BOOL)validationObject:(NSString *)str messges:(NSString *)msg
{
    if (str.length == 0) {
        
        hudShowError(msg);
        return NO;
    }
    return YES;
}


@end
