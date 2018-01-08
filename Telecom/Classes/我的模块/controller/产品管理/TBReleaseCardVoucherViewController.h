//
//  TBReleaseCardVoucherViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 发布类型
 
 - ReleaseTypeVouchers: 抵用券
 - ReleaseTypeDiscount: 打折卡
 */
typedef NS_ENUM(NSInteger ,ReleaseType) {
    
    ReleaseTypeVouchers = 0,
    ReleaseTypeDiscount
};
#import "TBBaseViewController.h"
@class TBDiscountsMode;
/**
 发布卡券
 */
@interface TBReleaseCardVoucherViewController : TBBaseViewController

- (instancetype)initReleaseType:(ReleaseType)type shopid:(NSString *)shopid;

@property (nonatomic ,strong) TBDiscountsMode *list;

@end
