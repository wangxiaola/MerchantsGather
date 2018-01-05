//
//  NSObject+MJExtension.m
//  CountryTouristAdministration
//
//  Created by 汤亮 on 16/8/1.
//  Copyright © 2016年 daqsoft. All rights reserved.
//

#import "NSObject+MJExtension.h"
#import "MJExtension.h"

@implementation NSObject (MJExtension)

+ (NSMutableArray *)dq_objectArrayWithKeyValuesArray:(id)keyValuesArray
{
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}

+ (instancetype)dq_objectWithKeyValues:(id)keyValues
{
    return [self mj_objectWithKeyValues:keyValues];
}

@end
