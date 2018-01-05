//
//  TBBaseClassTableViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBBaseClassTableViewController : TBBaseViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Class modeClass;

@property (nonatomic, strong) NSMutableDictionary *parameter;

@property (nonatomic, strong) NSMutableArray *roots;

- (void)initData NS_REQUIRES_SUPER;
- (void)setUpView NS_REQUIRES_SUPER;
- (void)endDataRequest;//数据请求结束
- (void)updataTableView;
@end
