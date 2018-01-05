//
//  TBRegionESRootClass.m
//  Telecom
//
//  Created by 王小腊 on 2017/7/17.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBRegionESRootClass.h"

@implementation TBRegionESRootClass

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TBRegionData class]};
}

@end

@implementation TBRegionData

+ (NSDictionary *)objectClassInArray{
    return @{@"children" : [TBRegionCityChildren class]};
}

@end


@implementation TBRegionCityChildren

+ (NSDictionary *)objectClassInArray{
    return @{@"children" : [TBRegionAreaChildren class]};
}

@end


@implementation TBRegionAreaChildren

@end





