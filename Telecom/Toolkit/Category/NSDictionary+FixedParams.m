//
//  NSDictionary+FixedParams.m
//  slyjg
//
//  Created by 汤亮 on 16/5/16.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "NSDictionary+FixedParams.h"

@implementation NSDictionary (FixedParams)

+ (instancetype)params
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"format"]  = @"json";
    params[@"AppId"]  = @"2zPhtu3ittzt";
    params[@"AppKey"]  = @"e22eb607c64b4df5a676ffc1274300a3";
    params[@"TimeStamp"]  = [ZKUtil timeStamp];
    return params;
}

@end
