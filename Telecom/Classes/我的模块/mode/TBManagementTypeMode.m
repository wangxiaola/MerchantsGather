//
//  TBManagementTypeMode.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBManagementTypeMode.h"


@implementation TBManagementTypeMode

+ (NSDictionary *)objectClassInArray{
    return @{@"root" : [TBManagementRoot class]};
}
@end

@implementation TBManagementRoot
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end



