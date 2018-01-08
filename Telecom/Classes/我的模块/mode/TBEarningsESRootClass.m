//
//  TBEarningsESRootClass.m
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBEarningsESRootClass.h"

@implementation TBEarningsESRootClass

+ (NSDictionary *)objectClassInArray{
    return @{@"root" : [TBEarningsRoot class]};
}

@end

@implementation TBEarningsRoot

+ (NSDictionary *)objectClassInArray{
    return @{@"details" : [TBEarningsDetails class]};
}

@end


@implementation TBEarningsDetails


@end



