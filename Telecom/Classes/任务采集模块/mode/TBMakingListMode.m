//
//  TBMakingListMode.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/15.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBMakingListMode.h"

@implementation TBMakingListMode

//表名
+ (NSString *)getTableName
{
    NSString *name = [UserInfo account].phone;
    return [NSString stringWithFormat:@"LKTable_%@",name];
}

@end
