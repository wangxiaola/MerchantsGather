//
//  TBBusinessIntelligenceViewMode.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBusinessIntelligenceViewMode.h"

@implementation TBBusinessIntelligenceViewMode

- (void)postLabels;
{
    NSMutableDictionary *dic = [NSMutableDictionary params];
    dic[@"interfaceId"] = @"178";
    dic[@"type"] = @"service";
    
    [ZKPostHttp post:@"" params:dic cacheType:ZKCacheTypeReturnCacheDataThenLoad success:^(NSDictionary *responseObj) {
        
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        if ([errcode isEqualToString:@"00000"])
        {
            [ZKUtil cacheForData:[responseObj mj_JSONData] fileName:@"TBBusinessIntelligenceViewMode"];
            [self processingTypeData:responseObj];
        }
    } failure:nil];
    
}
- (void)processingTypeData:(NSDictionary *)dic
{
    NSString *errcode = [dic valueForKey:@"errcode"];
    if ([errcode isEqualToString:@"00000"])
    {
        NSDictionary *data = [dic valueForKey:@"data"];
        
        TBBasicServicetypeMode *labes = [TBBasicServicetypeMode mj_objectWithKeyValues:data];
        
        if (self.servicetypeMode)
        {
            self.servicetypeMode(labes);
        }
    }
    
}
@end
