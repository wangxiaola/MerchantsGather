//
//  TBManagementViewMode.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBManagementViewMode.h"

#import "TBManagementTypeMode.h"


@interface TBManagementViewMode ()


@end
@implementation TBManagementViewMode

/**
 请求
 
 @param parameter 参数
 */
- (void)postDataParameter:(NSMutableDictionary *)parameter;
{
    TBWeakSelf
    [ZKPostHttp post:@"" params:parameter cacheType:ZKCacheTypeReloadIgnoringLocalCacheData success:^(NSDictionary *obj) {
        
        NSString *errcode = [obj valueForKey:@"errcode"];
        if ([errcode isEqualToString:@"00000"])
        {
            NSDictionary *data = [[obj valueForKey:@"data"] valueForKey:@"shops"];
            [weakSelf dataCard:data];

        }
        else
        {
            if ([weakSelf.delegate respondsToSelector:@selector(postError:)])
            {
                [weakSelf.delegate postError:@"数据异常！"];
            }
        }
        
    } failure:^(NSError *error) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(postError:)])
        {
            [weakSelf.delegate postError:@"网络异常！"];
        }
    }];
}
- (void)dataCard:(NSDictionary *)obj
{
    TBManagementTypeMode *mode = [TBManagementTypeMode mj_objectWithKeyValues:obj];
    
    if ([self.delegate respondsToSelector:@selector(postDataEnd:)])
    {
        [self.delegate postDataEnd:mode.root];
    }
    
    if (mode.root.count <20)
    {
        if ([self.delegate respondsToSelector:@selector(noMoreData)])
        {
            [self.delegate noMoreData];
        }
    }

}
@end
