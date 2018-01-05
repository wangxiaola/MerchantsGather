//
//  TBMonthlyIncomeViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"

/**
 当月收益列表
 */
@interface TBMonthlyIncomeViewController : TBBaseViewController

/**
 收益类型
 */
@property (nonatomic, assign) NSInteger type;

/**
 日期字符串
 */
@property (nonatomic, strong) NSString *dateString;
@end
