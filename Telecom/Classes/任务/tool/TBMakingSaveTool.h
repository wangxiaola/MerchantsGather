//
//  TBMakingSaveTool.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/15.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBMakingListMode.h"

@interface TBMakingSaveTool : NSObject

/**
 保存一个对象

 @param list 模型
 @param state 是否保存成功
 */
- (void)saveMakingList:(TBMakingListMode *)list saveState:(void (^)(BOOL state))state;

/**
 更新数据

 @param list 模型
 @param state 是否更新成功
 */
- (void)updataMakingList:(TBMakingListMode *)list updataState:(void (^)(BOOL state))state;

/**
 保存一组模型
 
 @param listArray 模型数组
 @param state 是否成功
 */
- (void)saveMakingListArray:(NSArray <TBMakingListMode *> *)listArray saveState:(void (^)(BOOL state))state;

/**
 删除一条数据

 @param list 模型
 @param state 是否删除成功
 */
- (void)deleteMakingList:(TBMakingListMode *)list deleteState:(void (^)(BOOL state))state;

/**
 删除一组数据

 @param listArray 模型数据
 @param state 是否删除成功
 */
- (void)deleteMakingListArray:(NSArray <TBMakingListMode *> *)listArray deleteState:(void (^)(BOOL state))state;

/**
 查询数据

 @param range 0,10  就是从0条最大取到10条
 @param results 成功返回
 */

- (void)queryConditionsRange:(NSRange )range results:(void (^)(NSArray <TBMakingListMode *>*listArray))results;

/**
 查询所有数据
 
 @param results 成功返回
 */
- (void)queryConditionsResults:(void (^)(NSArray <TBMakingListMode *>*listArray))results;
/**
 获取表单数据总数

 @param list 表单 TBMakingListMode
 @param count 数量
 */
- (void)queryTableData:(Class)list dataCount:(void (^)(NSInteger row))count;

/**
 删除全部数据

 @param state 是否成功
 */
- (void)deleteTabelAllState:(void (^)(BOOL state))state;

@end
