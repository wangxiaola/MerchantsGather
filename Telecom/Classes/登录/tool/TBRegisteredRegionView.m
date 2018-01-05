//
//  TBRegisteredRegionView.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBRegisteredRegionView.h"

@interface TBRegisteredRegionView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSArray <TBRegisteredRegionMode *>*dataArray;

@property (nonatomic, strong) NSString *selectKey;

@end

@implementation TBRegisteredRegionView
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
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
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

- (void)showAdderssPois:(NSArray <TBRegisteredRegionMode*>*)array;
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
    cell.backgroundColor = NAVIGATION_COLOR;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    TBRegisteredRegionMode *poi = self.dataArray[indexPath.row];
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


@end

@implementation TBRegisteredRegionMode
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}


@end
