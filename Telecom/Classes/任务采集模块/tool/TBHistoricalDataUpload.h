//
//  TBHistoricalDataUpload.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/22.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TBMakingListMode;

/**
 历史数据上传
 */
@interface TBHistoricalDataUpload : NSObject

typedef void(^historyData) (NSArray <TBMakingListMode *>*array);

@property (nonatomic, copy) historyData deleteSuccess;

/**
 数据上传

 @param array 数据
 @param historyArray 删除成功的数据
 */
- (void)updataArray:(NSArray <TBMakingListMode *>*)array deleteArray:(historyData)historyArray;

@end
