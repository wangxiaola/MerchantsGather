//
//  TBDiscountCouponMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/11.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 优惠团购
 */
@interface TBDiscountCouponMode : NSObject

@property (nonatomic, strong) NSString *logo;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSString *edate;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *origin;

@property (nonatomic, strong) NSString *state;//1-进行中,2-未开始3-结束

@property (nonatomic, strong) NSString *sdate;

@property (nonatomic, strong) NSString *info;

@property (nonatomic, strong) NSString *shopname;

@property (nonatomic, assign) CGFloat priceWidth;

@property (nonatomic, strong) NSString *totalnumber;

@property (nonatomic, strong) NSString *total;

@end
