//
//  TBBaseClassViewMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/11.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBBaseClassViewModeDelegate <NSObject>
@optional
/**
 原生数据
 
 @param dictionary 数据
 */
- (void)originalData:(NSDictionary *)dictionary;
/**
 请求结束
 
 @param dataArray 数据源
 */
- (void)postDataEnd:(NSArray *)dataArray;

/**
 请求出错了
 
 @param error 错误信息
 */
- (void)postError:(NSString *)error;

/**
 没有更多数据了
 */
- (void)noMoreData;

@end
@interface TBBaseClassViewMode : NSObject

/**
 请求
 
 @param parameter 参数
 */
- (void)postDataParameter:(NSMutableDictionary *)parameter;


@property (nonatomic, assign) id<TBBaseClassViewModeDelegate>delegate;

@end
