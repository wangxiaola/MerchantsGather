//
//  TBReleasePreviewViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBReleasePreviewViewController.h"
#import "TBReleasePreviewPhotoView.h"
#import "TBPublishingGroupViewMode.h"
#import "TBMoreReminderView.h"
#import "TBPublishingGroupList.h"
#import "TBReleasePreviewHeadeTableViewCell.h"
#import "TBReleasePreviewInfoTableViewCell.h"

static NSString *const HeadeTableViewCellID = @"HeadeTableViewCellID";
static NSString *const InfoTableViewCellID = @"InfoTableViewCellID";

@interface TBReleasePreviewViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _cellShow[2];
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TBReleasePreviewPhotoView *photoView;
@property (nonatomic, strong) NSMutableArray *dictionaryArray;//区间一的信息
@property (nonatomic, strong) NSMutableArray *instructionsArray;//购买须知
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, assign) CGFloat cellHeight_introduce;//介绍高度
@property (nonatomic, assign) CGFloat cellHeight_instructions;//须知
@property (nonatomic, strong) TBPublishingGroupViewMode *viewMode;
@property (nonatomic, strong) TBReleasePreviewInfoTableViewCell *infoCell;

@end

@implementation TBReleasePreviewViewController
- (TBPublishingGroupViewMode *)viewMode
{
    if (!_viewMode)
    {
        _viewMode = [[TBPublishingGroupViewMode alloc] init];
    }
    return _viewMode;
}

- (NSMutableDictionary *)dictionary
{
    if (!_dictionary)
    {
        _dictionary = [NSMutableDictionary params];
    }
    _dictionary[@"TimeStamp"]  = [ZKUtil timeStamp];
    return _dictionary;
}
- (TBPublishingGroupList *)groupList
{
    if (_groupList == nil)
    {
        _groupList = [[TBPublishingGroupList alloc] init];
    }
    return _groupList;
}
- (NSMutableArray *)instructionsArray
{
    if (!_instructionsArray)
    {
        _instructionsArray = [NSMutableArray array];
        
    }
    return _instructionsArray;
    
}
- (NSMutableArray *)dictionaryArray
{
    if (!_dictionaryArray)
    {
        _dictionaryArray = [NSMutableArray array];
    }
    return _dictionaryArray;
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
    if (self.groupId.integerValue == 0)
    {
        [self addDictionary];
        self.navigationItem.title = @"发布预览";
    }
    else
    {
        self.navigationItem.title = @"团购秒杀详情";
        TBWeakSelf
        //请求数据
        [self.viewMode postPublishingGroupData:self.groupId groupData:^(TBPublishingGroupList *list) {
            weakSelf.groupList = list;
            [weakSelf addDictionary];
        }];
        
    }
    
}
#pragma mark -- 视图设置 ---
//创建视图
- (void)createViews
{
    //初始化bool数组Flag，此处用到了函数memset( )，该函数有3个参数需要传入，第一个参数是数组的名称，第二个参数是初始化的值，第三个参数是数组的大小
    memset(_cellShow,YES,sizeof(_cellShow));
    CGFloat bottomHeight = self.groupId.integerValue > 0 ?0.0f:44;
    [self.view addSubview:self.tableView];
    
    self.photoView = [[TBReleasePreviewPhotoView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, _SCREEN_WIDTH*0.5)];
    self.tableView.tableHeaderView = self.photoView;
    [self.tableView registerClass:[TBReleasePreviewHeadeTableViewCell class] forCellReuseIdentifier:HeadeTableViewCellID];
    [self.tableView registerClass:[TBReleasePreviewInfoTableViewCell class] forCellReuseIdentifier:InfoTableViewCellID];
    self.photoView.backgroundColor = [UIColor redColor];
    
    self.infoCell = [self.tableView dequeueReusableCellWithIdentifier:InfoTableViewCellID];
    TBWeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-bottomHeight);
    }];
    if (self.groupId.integerValue == 0)
    {
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.backgroundColor = RGB(25, 189, 151);
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton setTitle:@"确认发布" forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:confirmButton];
        
        UIButton *modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        modifyButton.backgroundColor = RGB(251, 133, 55);
        [modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [modifyButton setTitle:@"返回修改" forState:UIControlStateNormal];
        modifyButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [modifyButton addTarget:self action:@selector(modifyClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:modifyButton];
        
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(weakSelf.view);
            make.right.equalTo(modifyButton.mas_left);
            make.height.mas_equalTo(bottomHeight);
        }];
        [modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(weakSelf.view);
            make.height.mas_equalTo(bottomHeight);
            make.width.equalTo(confirmButton.mas_width);
        }];
        
    }
}
- (void)addDictionary
{
    if (self.groupList)
    {
        [self.dictionaryArray removeAllObjects];
        [self.instructionsArray removeAllObjects];
        NSString *price = [NSString stringWithFormat:@"￥%@",self.groupList.price];
        NSString *sellprice = [NSString stringWithFormat:@"￥%@",self.groupList.sellprice];
        NSString *qxDate = [NSString stringWithFormat:@"%@ 至 %@",self.groupList.sdate,self.groupList.edate];
        [self.dictionaryArray addObject:@{@"leftName":@"产品名称：",@"rightName":self.groupList.name}];
        [self.dictionaryArray addObject:@{@"leftName":@"产品原价：",@"rightName":price}];
        [self.dictionaryArray addObject:@{@"leftName":@"团购价格：",@"rightName":sellprice}];
        [self.dictionaryArray addObject:@{@"leftName":@"秒杀套数：",@"rightName":self.groupList.num}];
        [self.dictionaryArray addObject:@{@"leftName":@"预约电话：",@"rightName":self.groupList.ginfo}];
        
        [self.dictionaryArray addObject:@{@"leftName":@"使用期限：",@"rightName":qxDate}];
        [self.dictionaryArray addObject:@{@"leftName":@"上线时间：",@"rightName":self.groupList.time}];
        
        NSString *bookdate = self.groupList.bookdate.integerValue == 0?@"不需要预约时间":[NSString stringWithFormat:@"使用时至少提前%@天预约时间",self.groupList.bookdate];
        NSString *limitnum = self.groupList.limitnum.integerValue == 0?@"不限制购买数量":[NSString stringWithFormat:@"每人最多购买%@份",self.groupList.limitnum];
        NSString *refund = self.groupList.refund.integerValue == 0?@"购买后不可退款":[NSString stringWithFormat:@"未消费，已过期%@天内支持退款",self.groupList.refund];
        
        [self.instructionsArray addObject:bookdate];
        [self.instructionsArray addObject:limitnum];
        [self.instructionsArray addObject:refund];
        if (self.groupList.buyknow.length>0)
        {
            [self.instructionsArray addObject:self.groupList.buyknow];
        }
        [self.photoView updataPhotoArray:self.groupList.imgs photoName:self.groupList.shopname];
        self.cellHeight_introduce = 0.0f;
        self.cellHeight_instructions = 0.0f;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView reloadData];
        
    }
}
#pragma mark ---点击事件---
- (void)confirmClick
{
    TBMoreReminderView *moreView = [[TBMoreReminderView alloc] initShowPrompt:@"确认发布团购秒杀吗？"];
    TBWeakSelf
    [moreView showHandler:^{
        [weakSelf.viewMode requestData:weakSelf.groupList successful:^{
            
            [weakSelf requestSuccessful];
        }];
    }];
}

/**
 发布成功
 */
- (void)requestSuccessful
{
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:CardVoucherNotice object:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2]
                                          animated:YES];;
}
- (void)modifyClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 cell按钮事件
 
 @param row 第几个
 */
- (void)showCellIndex:(NSInteger)row
{
    _cellShow[row-1] = !_cellShow[row-1];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:row] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark ---UITableViewDelegate---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupList.name.length>0?3:0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.groupList.name.length == 0)
    {
        return 0;
    }
    if (section == 0)
    {
        return 7;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.row == 0)
    {
        return 44.0f;
    }
    
    BOOL show = _cellShow[indexPath.section-1];
    if (indexPath.section == 1)
    {
        if (self.cellHeight_introduce == 0)
        {
            self.cellHeight_introduce = [self calculateCellheightIndex:indexPath.section];
        }
        return show == YES?self.cellHeight_introduce:0.01f;
    }
    if (indexPath.section == 2)
    {
        if (self.cellHeight_instructions == 0)
        {
            self.cellHeight_instructions = [self calculateCellheightIndex:indexPath.section];
        }
        return show == YES?self.cellHeight_instructions:0.01f;
    }
    
    return 0.01f;
}
- (CGFloat)calculateCellheightIndex:(NSInteger)index
{
    NSArray *array = index == 1?self.groupList.info:self.instructionsArray;
    __block CGFloat cellHeight = 0.0f;
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        cellHeight = cellHeight + [ZKUtil contentLabelSize:CGSizeMake(_SCREEN_WIDTH - 20 , 200) labelFont:[UIFont systemFontOfSize:14] labelText:obj].height+4;
    }];
    return cellHeight +20;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *const cellIdentifier = @"cellText";
        UITableViewCell *cellText = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cellText)
        {
            cellText = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cellText.textLabel.textColor = [UIColor blackColor];
            cellText.textLabel.font = [UIFont systemFontOfSize:14];
            cellText.detailTextLabel.textColor = indexPath.row == 2?RGB(23, 181, 146):[UIColor grayColor];
            cellText.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }
        if (self.dictionaryArray.count> indexPath.row)
        {
            NSDictionary *dic = self.dictionaryArray[indexPath.row];
            cellText.textLabel.text = [dic valueForKey:@"leftName"];
            cellText.detailTextLabel.text = [dic valueForKey:@"rightName"];
        }
        cellText.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellText;
    }
    
    if (indexPath.row == 0)
    {
        TBReleasePreviewHeadeTableViewCell *headeCell = [tableView dequeueReusableCellWithIdentifier:HeadeTableViewCellID];
        TBWeakSelf
        [headeCell updataText:indexPath.section == 1?@"产品介绍":@"购买须知" state:_cellShow[indexPath.section-1] buttonClick:^{
            [weakSelf showCellIndex:indexPath.section];
        }];
        
        headeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return headeCell;
    }
    else
    {
        TBReleasePreviewInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:InfoTableViewCellID];
        
        [infoCell updataArray:indexPath.section == 1?self.groupList.info:self.instructionsArray];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return infoCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
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
