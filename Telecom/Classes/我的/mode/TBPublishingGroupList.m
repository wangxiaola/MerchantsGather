//
//  TBPublishingGroupList.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBPublishingGroupList.h"

@implementation TBPublishingGroupList
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    
    // property 属性名称，oldValue 返回数据
    if ([property.name isEqualToString:@"imgs"])
    {
       return [oldValue componentsSeparatedByString:IMAGE_OPERATOR];
        
    }
    if ([property.name isEqualToString:@"info"])
    {
        return  [oldValue componentsSeparatedByString:IMAGE_OPERATOR];
    }
    
    return oldValue;
}
@end
