//
//  TBShowAddressResultsView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBShowAddressResultsView.h"
#import <AMapSearchKit/AMapCommonObj.h>

@interface TBShowAddressResultsView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSArray <AMapPOI *>*dataArray;

@property (nonatomic, strong) NSString *selectKey;

@end
@implementation TBShowAddressResultsView
{

    UITableView *_tableView;
    
    UIView *contenView;
    
    float tableWidth;
}

- (instancetype)init;
{
    self = [super init];
    if (self)
    {
        
        contenView = [[UIView alloc] init];
        //shadowColor阴影颜色
        contenView.layer.shadowColor = [UIColor blackColor].CGColor;
        //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        contenView.layer.shadowOffset = CGSizeMake(-3,3);
        //阴影透明度，默认0
        contenView.layer.shadowOpacity = 0.8;
        //阴影半径，默认3
        contenView.layer.shadowRadius = 4;
        contenView.clipsToBounds = YES;
        [self addSubview:contenView];
        
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 20;
        _tableView.delegate = self;
        _tableView.dataSource = self;

        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [contenView addSubview:_tableView];
        
        [contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self);
        }];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(contenView);
        }];
        
    }
    
    return self;
    
}

- (void)showAdderssPois:(NSArray <AMapPOI*>*)array;
{
    self.dataArray = array;
    [_tableView reloadData];

}
#pragma mark ---UITableViewDelegate---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor blackColor];
    [cell.textLabel sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    AMapPOI *poi = self.dataArray[indexPath.row];
    cell.textLabel.text = poi.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView moveSection:0 toSection:0];
    
    if (self.adderssPoi)
    {
        self.adderssPoi(self.dataArray[indexPath.row]);
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
