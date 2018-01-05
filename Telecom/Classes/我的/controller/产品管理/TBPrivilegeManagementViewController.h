//
//  TBPrivilegeManagementViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//


/**
 优惠管理类型

 - ManagementTypeVouchers: 抵用券
 - ManagementTypeDiscount: 打折卡
 */
typedef NS_ENUM(NSInteger ,ManagementType) {

    ManagementTypeVouchers = 0,
    ManagementTypeDiscount
};
#import "TBBaseClassTableViewController.h"
@class TBManagementRoot;
/**
 优惠管理
 */
@interface TBPrivilegeManagementViewController : TBBaseClassTableViewController
// 管理类型
@property (nonatomic) ManagementType managementType;
// 数据
@property (nonatomic, strong) TBManagementRoot *managementRoot;

/**
 优惠列表类型
 */
@property (nonatomic, assign) NSInteger state;
@end
