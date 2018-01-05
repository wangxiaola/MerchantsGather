//
//  TBFinancialActivateViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/6/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBWebViewController.h"

/**
 云金融激活web
 */
@interface TBFinancialActivateViewController : TBWebViewController

/**
 初始化

 @param phone 商户电话
 @return self
 */
- (instancetype)initMerchantsPhone:(NSString *)phone;

@end
