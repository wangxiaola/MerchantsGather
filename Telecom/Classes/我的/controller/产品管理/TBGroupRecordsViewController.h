//
//  TBGroupRecordsViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/13.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseClassTableViewController.h"
@class TBDiscountCouponMode;

/**
 团购记录
 */
@interface TBGroupRecordsViewController : TBBaseClassTableViewController

@property (nonatomic, strong) TBDiscountCouponMode *list;

@end
