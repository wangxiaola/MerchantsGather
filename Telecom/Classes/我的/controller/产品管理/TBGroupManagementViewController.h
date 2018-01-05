//
//  TBGroupManagementViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseClassTableViewController.h"
@class TBManagementRoot;
/**
 团购管理
 */
@interface TBGroupManagementViewController : TBBaseClassTableViewController
// 数据
@property (nonatomic, strong) TBManagementRoot *managementRoot;

/**
 团购列表类型
 */
@property (nonatomic, assign) NSInteger state;
@end
