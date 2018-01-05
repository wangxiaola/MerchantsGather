
//
//  MyTaskDetailController.m
//  Telecom
//
//  Created by zhangxingdong 张兴栋 on 16/12/7.
//  Copyright © 2016年 王小腊. All rights reserved.
//
#import "MyTaskCell.h"
#import "MyTaskDetailController.h"

static NSString *const MyTaskCell_ID = @"MyTaskCell_ID";

@interface MyTaskDetailController ()

@end

@implementation MyTaskDetailController

- (void)viewDidLoad {
  [super viewDidLoad];
   self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    if (self.view.bounds.size.width > 415) {
         self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44 - 40 -28) style:UITableViewStyleGrouped];
    } else {
     self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44 -40 - 40) style:UITableViewStyleGrouped];
    }
  
   self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 0.00001)];
   self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 0.00001)];
  [self.tableView registerNib:[UINib nibWithNibName:@"MyTaskCell" bundle:nil] forCellReuseIdentifier:MyTaskCell_ID];
   self.view.backgroundColor = NAVIGATION_COLOR;
}


#pragma mark --- UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyTaskCell_ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
