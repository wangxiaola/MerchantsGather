//
//  TBTaskListMode.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTaskListMode.h"

@implementation TBTaskListMode

@end
@implementation TBTaskListData

@end


@implementation TBTaskListShops

+ (NSDictionary *)objectClassInArray{
    return @{@"root" : [TBTaskListRoot class]};
}

@end


@implementation TBTaskListRoot
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


