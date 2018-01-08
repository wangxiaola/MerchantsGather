//
//  TBEarningsViewMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBEarningsViewModeDelegate <NSObject>

/**
 请求结束
 
 @param dic 数据源
 */
- (void)postDataEnd:(NSDictionary *)dic;

/**
 请求出错了
 
 @param error 错误信息
 */
- (void)postError:(NSString *)error;

@end

@interface TBEarningsViewMode : NSObject

/**
 请求
 
 @param parameter 参数
 */
- (void)postDataParameter:(NSMutableDictionary *)parameter;

@property (nonatomic, assign) id<TBEarningsViewModeDelegate>delegate;

@end
