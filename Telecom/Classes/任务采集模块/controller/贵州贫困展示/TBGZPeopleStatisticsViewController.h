//
//  TBGZPeopleStatisticsViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/11/17.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"

/**
 贵州-贫困数据展示
 */
@interface TBGZPeopleStatisticsViewController : TBBaseViewController

/**
 创建弹出视图

 @param data 数据
 @return self
 */
- (instancetype)initShowData:(NSDictionary *)data;
@end
