//
//  TBBasicServicetypeMode.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBasicServicetypeMode.h"

@implementation TBBasicServicetypeMode

+ (NSDictionary *)objectClassInArray
{
    return @{@"range" : [TBBasicServicetypeRange class], @"servicelables" : [TBBasicServicetypeServicelables class]};
}
@end


@implementation TBBasicServicetypeRange

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end



@implementation TBBasicServicetypeServicelables

+ (NSDictionary *)objectClassInArray{
    return @{@"labels" : [TBBasicServicetypeLabels class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


@implementation TBBasicServicetypeLabels
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


