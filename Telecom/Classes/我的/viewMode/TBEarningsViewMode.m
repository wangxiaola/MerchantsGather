//
//  TBEarningsViewMode.m
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBEarningsViewMode.h"

@interface TBEarningsViewMode()

@end
@implementation TBEarningsViewMode

/**
 请求
 
 @param parameter 参数
 */
- (void)postDataParameter:(NSMutableDictionary *)parameter;
{
    TBWeakSelf

    [ZKPostHttp post:@"" params:parameter success:^(id responseObj) {
    
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        if ([errcode isEqualToString:@"00000"])
        {
            NSDictionary *dataDic = [responseObj valueForKey:@"data"];
            [weakSelf dataCard:dataDic];
            
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
    
    if ([self.delegate respondsToSelector:@selector(postDataEnd:)])
    {
        [self.delegate postDataEnd:obj];
    }
}

@end
