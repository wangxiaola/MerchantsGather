//
//  TBHomeDataMode.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/15.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBHomeDataMode.h"

@implementation TBHomeDataMode

@end


@implementation TBHomeData

@end


@implementation TBHomeShops

+ (NSDictionary *)objectClassInArray{
    return @{@"root" : [TBHomeShopsRoot class]};
}

@end


@implementation TBHomeShopsRoot
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end

@implementation TBHomeModelsRoot
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end

@implementation TBHomeModels

+ (NSDictionary *)objectClassInArray{
    return @{@"root" : [TBHomeModelsRoot class]};
}

@end



