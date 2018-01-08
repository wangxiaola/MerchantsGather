//
//  TBManagementViewMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBManagementViewModeDelegate <NSObject>

/**
 请求结束

 @param array 数据源
 */
- (void)postDataEnd:(NSArray *)array;

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

@interface TBManagementViewMode : NSObject

/**
 请求

 @param parameter 参数
 */
- (void)postDataParameter:(NSMutableDictionary *)parameter;


@property (nonatomic, assign) id<TBManagementViewModeDelegate>delegate;

@end
