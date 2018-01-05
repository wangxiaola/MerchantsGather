//
//  TBBusinessTypeViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//


/**
 采集类型选择

 - BusinessTypeZQL: 藏羌乐
 - BusinessTypeRecreation: 休闲娱乐
 - BusinessTypeFood: 美食
 - BusinessTypeHotel: 酒店
 - BusinessTypeView: 景区
 - BusinessTypeNone: 服务场所
 */
typedef NS_ENUM(NSInteger, BusinessType) {
    BusinessTypeZQL = 0,
    BusinessTypeRecreation ,
    BusinessTypeFood,
    BusinessTypeHotel,
    BusinessTypeView,
    BusinessTypeNone
};
#import "TBBaseViewController.h"

/**
 商家类型进入
 */
@interface TBBusinessTypeViewController : TBBaseViewController

@property (nonatomic) BusinessType businessType;

@end
