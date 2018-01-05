//
//  TBGroupSpecificationView.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/13.
//  Copyright © 2017年 王小腊. All rights reserved.
//

static NSString *const TBGroupSpecificationTableViewCellID = @"TBGroupSpecificationTableViewCellID";
#import "TBGroupSpecificationView.h"
#import "TBGroupSpecificationTableViewCell.h"
#import "TBMoreReminderView.h"
@interface TBGroupSpecificationView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
//数据
@property (nonatomic, strong) NSMutableArray *infoArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) CGFloat tableViewHieght;
@property (nonatomic, assign) CGFloat tableViewCellHieght;
@end

@implementation TBGroupSpecificationView
#pragma mark --- 数据初始化---
- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray arrayWithCapacity:self.maxNumber];
    }
    return _dataArray;
}
- (NSMutableArray *)infoArray
{
    if (!_infoArray)
    {
        _infoArray = [NSMutableArray arrayWithCapacity:self.maxNumber];
    }
    
    return _infoArray;
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TBGroupSpecificationTableViewCell class]) bundle:nil] forCellReuseIdentifier:TBGroupSpecificationTableViewCellID];
    }
    return _tableView;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.tableViewHieght = 14.0f;
        self.tableViewCellHieght = 40;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(6);
            make.right.bottom.equalTo(self).offset(-6);
        }];
    }
    return self;
}
#pragma mark --接口方法---
/**
 更新布局
 
 @param height 高度
 */
- (void)updataViewHeight:(infoViewHeight)height;
{
    self.viewHeight = height;
}
/**
 更新布局显示
 
 @param infoArray 数据
 @param height 加载数据后的高度
 */
- (void)updataInfoArray:(NSArray *)infoArray;
{
    if (infoArray.count>0)
    {
        [self.infoArray removeAllObjects];
        [infoArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.length>0)
            {
                [self.infoArray addObject:obj];
            }
            
        }];
        self.tableViewHieght = self.tableViewHieght+self.tableViewCellHieght*self.infoArray.count;
        if (self.viewHeight)
        {
            self.viewHeight(self.tableViewHieght);
        }
        [self.tableView reloadData];
    }
}
/**
 新添加
 
 @param number 数量
 @param height 返回高度
 */
- (void)addInfoCellNumber:(NSInteger)number;
{
    if (self.infoArray.count+number >self.maxNumber)
    {
        hudShowError(@"不能再添加介绍了");
        return;
    }
    __block BOOL isNull = NO;
    [self.infoArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.length == 0)
        {
            isNull = YES;
        }
    }];
    if (isNull == YES)
    {
        hudShowError(@"还有数据未填写");
        return;
    }
    for (int i = 0 ; i<number; i++)
    {
        [self.infoArray addObject:@""];
    }
    
    self.tableViewHieght = self.tableViewHieght+self.tableViewCellHieght*number;
    if (self.viewHeight)
    {
        self.viewHeight(self.tableViewHieght);
    }
    [self.tableView reloadData];
}
/**
 获取介绍数据
 
 @return 数组
 */
- (NSArray *)accessToIntroduceData;
{
    [self.dataArray removeAllObjects];
    [self.infoArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length>0)
        {
            [self.dataArray addObject:obj];
        }
    }];

    return self.dataArray;
}
//删除cell
- (void)deleteCellIndex:(NSInteger)index
{
    if (self.infoArray.count == 1)
    {
        hudShowError(@"请至少填写一个产品介绍");
        return;
    }
    if (index<self.infoArray.count)
    {
        NSString *info = self.infoArray[index];
        if (info.length>0)
        {
            TBMoreReminderView *moreView = [[TBMoreReminderView alloc] initShowPrompt:[NSString stringWithFormat:@"确定删除第%ld条介绍吗？",(long)index+1]];
            TBWeakSelf
            [moreView showHandler:^{
                [weakSelf deleteInfoArrayIndex:index];
            }];
        }
        else
        {
            [self deleteInfoArrayIndex:index];
        }

    }
    else
    {
        hudShowError(@"数据异常");
    }
}
//删除第几条数据
- (void)deleteInfoArrayIndex:(NSInteger)row
{
    [self.infoArray removeObjectAtIndex:row];
    [self.tableView reloadData];
    self.tableViewHieght = self.tableViewHieght-self.tableViewCellHieght;
    if (self.viewHeight)
    {
        self.viewHeight(self.tableViewHieght);
    }
    [self.tableView reloadData];
}
//添加数据
- (void)addInfoString:(NSString *)info index:(NSInteger)row
{
    if (info&&row<self.infoArray.count)
    {
        [self.infoArray replaceObjectAtIndex:row withObject:info];
    }
    if (info.length>0&&row == self.infoArray.count-1&&row<self.maxNumber-1)
    {
        [self addInfoCellNumber:1];
    }
}
#pragma mark ---UITableViewDelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.infoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TBGroupSpecificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBGroupSpecificationTableViewCellID];
    cell.indexNameLabel.text = [NSString stringWithFormat:@"%ld、",(long)indexPath.row+1];
    if (indexPath.row<self.infoArray.count)
    {
        cell.infoTextField.text = [self.infoArray objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.ritButton.hidden = self.infoArray.count == 1;
    TBWeakSelf
    [cell setDeleteButton:^{
        
        [weakSelf deleteCellIndex:indexPath.row];
    }];
    [cell setCellText:^(NSString *text){
        [weakSelf addInfoString:text index:indexPath.row];
    }];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableViewCellHieght;
}

@end
