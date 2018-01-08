//
//  TBPreferentialBaseViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//


/**
 产品管理类型

 - FerentialTypeVouchers: 抵用券
 - FerentialTypeDiscount: 打折卡
 - FerentialTypeBulk: 团购
 */
typedef NS_ENUM(NSInteger ,FerentialType) {

    FerentialTypeVouchers = 0,
    FerentialTypeDiscount,
    FerentialTypeBulk
};

#import "TBBaseViewController.h"
@class TBManagementRoot;

/**
 产品优惠管理
 */
@interface TBPreferentialBaseViewController : TBBaseViewController

// 类型
@property (nonatomic) FerentialType ferentialType;
// 数据
@property (nonatomic, strong) TBManagementRoot *managementRoot;
@end
