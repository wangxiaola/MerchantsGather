//
//  TBGZEmployeesAddViewMode.m
//  Telecom
//
//  Created by 王小腊 on 2017/11/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBGZEmployeesAddViewMode.h"

@implementation TBGZEmployeesAddViewMode

- (void)validationData:(NSDictionary *)data validationResults:(void(^)(BOOL results, NSInteger code))results;
{
    NSString *url = [NSString stringWithFormat:@"https://gzitrip.cn/api/datashare/v1/poorpeople/%@",[data valueForKey:Key_iDCardTextField]];
    
    hudShowLoading(@"正在请求验证...");
    
    [ZKPostHttp getddByUrlPath:url andParams:nil andCallBack:^(id responseObj) {
        
        NSInteger tyoe = [[responseObj valueForKey:@"code"] integerValue];
        BOOL      isResults;
        if (responseObj == nil)
        {
            isResults = NO;
        }
        else
        {
            if (tyoe == 200)
            {
                isResults = YES;
            }
            else if (tyoe == 101)
            {
                isResults = YES;
            }
            else
            {
                isResults = NO;
            }
        }
        if (results)
        {
            results(isResults, tyoe);
        }
        hudDismiss();
    }];
    
}
/**
 创建原始数据
 
 @return 字典
 */
- (NSDictionary *)createTheRawData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"",Key_iDCardTextField,
                         @"",Key_nameTextfield,
                         @"",Key_phoneTextfield,
                         @"",Key_salaryTextfield,
                         @"",Key_ageTextfield,
                         @"",Key_jobsTextfield,
                         @"1",Key_gender,
                         @"1",Key_marriage,
                         @"2",Key_health,nil];//身份证数据是否改动
    return dic;
    
}

/**
 获取统计数据
 
 @param data 数据源
 @param results 计算结果
 */
- (void)obtainStatisticalResultsData:(NSArray *)data results:(void(^)(NSDictionary *data))results;
{
    TBWeakSelf
    __block  NSDictionary *dic;
    hudShowLoading(@"正在计算统计结果...");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dic =  [weakSelf statisticalResultsCalculatedData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            hudDismiss();
            if (results) {
                results(dic);
            }
        });
    });
}
/**
 获取统计数据
 
 @param data 数据源
 @return 统计结果
 */
- (NSDictionary *)statisticalResultsCalculatedData:(NSArray *)data;
{
    NSInteger menNum = 0;
    NSInteger womanNum = 0;
    NSInteger totalNum = 0;
    
    CGFloat lowSalary = 0;
    CGFloat highSalary = 0;
    CGFloat averageIncome = 0.0f;
    
    NSInteger below35Num = 0;
    NSInteger below65Num = 0;
    NSInteger above65Num = 0;
    
    for (int i = 0; i< data.count; i++) {
        
        NSDictionary *dic = data[i];
        CGFloat salary = [[dic valueForKey:Key_salaryTextfield] floatValue];
        NSInteger age  = [[dic valueForKey:Key_ageTextfield] integerValue];
        NSInteger gender = [[dic valueForKey:Key_gender] integerValue];
        
        averageIncome += salary;
        totalNum +=1;
        
        if (gender == 1)
        {
            menNum += 1;
        }
        else
        {
            womanNum += 1;
        }
        if (age < 35)
        {
            below35Num += 1;
        }
        else if (age < 65)
        {
            below65Num += 1;
        }
        else
        {
            above65Num += 1;
        }
        
        if (salary > highSalary) {
            highSalary = salary;
        }
        // 0   10
        if (i == 0)
        {
            lowSalary = salary;
        }
        else
        {
            if (salary < lowSalary) {
                lowSalary = salary;
            }
        }
    }
    
    NSDictionary *dic = @{@"menNum":[NSString stringWithFormat:@"%ld",menNum],
                          @"womanNum":[NSString stringWithFormat:@"%ld",womanNum],
                          @"totalNum":[NSString stringWithFormat:@"%ld",totalNum],
                          @"lowSalary":[NSString stringWithFormat:@"%.1f",lowSalary],
                          @"highSalary":[NSString stringWithFormat:@"%.1f",highSalary],
                          @"averageIncome":[NSString stringWithFormat:@"%.1f",averageIncome/totalNum],
                          @"below35Num":[NSString stringWithFormat:@"%ld",below35Num],
                          @"below65Num":[NSString stringWithFormat:@"%ld",below65Num],
                          @"above65Num":[NSString stringWithFormat:@"%ld",above65Num],
                          };
    return dic;
    
}
@end
