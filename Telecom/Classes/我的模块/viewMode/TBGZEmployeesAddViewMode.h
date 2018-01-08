//
//  TBGZEmployeesAddViewMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/11/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

// 身份证
static NSString *const Key_iDCardTextField   = @"iDCardText";
// 姓名
static NSString *const Key_nameTextfield     = @"nameText";
// 联系方式
static NSString *const Key_phoneTextfield    = @"phoneText";
// 薪资
static NSString *const Key_salaryTextfield   = @"salaryText";
// 年龄
static NSString *const Key_ageTextfield      = @"ageText";
// 岗位
static NSString *const Key_jobsTextfield     = @"jobsText";
// 性别
static NSString *const Key_gender            = @"gender";
// 婚姻
static NSString *const Key_marriage          = @"marriage";
// 健康状态
static NSString *const Key_health            = @"health";
// 是否是贫困人口 1是 0不是
static NSString *const Key_type              = @"type";

@interface TBGZEmployeesAddViewMode : NSObject

/**
 贫困员工验证

 @param data 数据
 @param results 结果
 */
- (void)validationData:(NSDictionary *)data validationResults:(void(^)(BOOL results, NSInteger code))results;

/**
 创建原始数据
 
 @return 字典
 */
- (NSDictionary *)createTheRawData;

/**
   获取统计数据

 @param data 数据源
 @param results 计算结果
 */
- (void)obtainStatisticalResultsData:(NSArray *)data results:(void(^)(NSDictionary *data))results;

@end
