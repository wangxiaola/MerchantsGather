//
//  TBMakingSaveTool.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/15.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBMakingSaveTool.h"
#import "LKDBHelper.h"

@interface TBMakingSaveTool ()

@property (nonatomic , strong) LKDBHelper *globalHelper;

@property (nonatomic, strong) NSMutableArray <TBMakingListMode *>* listArray;

@end
@implementation TBMakingSaveTool

- (NSMutableArray <TBMakingListMode *> *)listArray
{
    if (!_listArray)
    {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (LKDBHelper *)globalHelper
{
    if (_globalHelper == nil)
    {
        _globalHelper = [LKDBHelper  getUsingLKDBHelper];
        [LKDBHelper setLogError:YES];
        
    }
    
    return _globalHelper;
}
/**
 保存一个对象
 
 @param list 模型
 @param state 是否保存成功
 */
- (void)saveMakingList:(TBMakingListMode *)list saveState:(void (^)(BOOL state))state;
{
    if (list)
    {
        [self.globalHelper insertToDB:[self transformation:list] callback:^(BOOL result)
         {
             state(result);
             
         }];
    }
    else
    {
        state(NO);
    }
}

/**
 保存一组模型
 
 @param listArray 模型数组
 @param state 是否成功
 */
- (void)saveMakingListArray:(NSArray <TBMakingListMode *> *)listArray saveState:(void (^)(BOOL state))state;
{

    if (listArray)
    {
        [listArray enumerateObjectsUsingBlock:^(TBMakingListMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.globalHelper insertToDB:[self transformation:obj]];
        }];
        
        state (YES);
    }
    else
    {
        state(NO);
    }
    
}

/**
 更新数据
 
 @param list 模型
 @param state 是否更新成功
 */
- (void)updataMakingList:(TBMakingListMode *)list updataState:(void (^)(BOOL state))state;
{
    
    if (list)
    {
        [self makingTransformation:@[list] results:^(NSArray<TBMakingListMode *> *results)
         {
             if (results.count == 1)
             {
                 [self.globalHelper updateToDB:results.firstObject where:nil callback:^(BOOL result)
                  {
                      state(result);
                      
                  }];
             }
             else
             {
                 state(NO);
             }
             
         } failure:^(NSError *error) {
             
             state(NO);
         }];
        
        
    }
    else
    {
        state(NO);
    }
    
}
/**
 删除一条数据
 
 @param list 模型
 @param state 是否删除成功
 */
- (void)deleteMakingList:(TBMakingListMode *)list deleteState:(void (^)(BOOL state))state;
{
    if (list)
    {
        [self.globalHelper deleteToDB:[self transformation:list] callback:^(BOOL result) {
            
            state (result);
        }];
    }
    else
    {
        state(NO);
    }
}

/**
 删除一组数据
 
 @param listArray 模型数据
 @param state 是否删除成功
 */
- (void)deleteMakingListArray:(NSArray <TBMakingListMode *> *)listArray deleteState:(void (^)(BOOL state))state;
{
    if (listArray)
    {
        [listArray enumerateObjectsUsingBlock:^(TBMakingListMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.globalHelper deleteToDB:obj];
            
        }];
        
        state(YES);
    }
    else
    {
        state(NO);
    }
}

/**
 查询数据
 
 @param range 0,10  就是从0条最大取到10条
 @param results 成功返回
 */
- (void)queryConditionsRange:(NSRange )range results:(void (^)(NSArray <TBMakingListMode *>*listArray))results;
{
        [self.globalHelper search:[TBMakingListMode class] where:nil orderBy:nil offset:range.location count:range.length callback:^(NSMutableArray <TBMakingListMode *>* array) {
            
            results(array);
            
        }];
}
/**
 查询所有数据
 
 @param results 成功返回
 */
- (void)queryConditionsResults:(void (^)(NSArray <TBMakingListMode *>*listArray))results;
{
    [self.globalHelper search:[TBMakingListMode class] where:nil orderBy:nil offset:0 count:0 callback:^(NSMutableArray <TBMakingListMode *>* array) {
        
        results(array);
        
    }];
}
/**
 获取表单数据总数
 
 @param list 表单 TBMakingListMode
 @param count 数量
 */
- (void)queryTableData:(Class)list dataCount:(void (^)(NSInteger row))count;
{
    [self.globalHelper rowCount:[TBMakingListMode class] where:nil callback:^(NSInteger rowCount) {
        
        count(rowCount);
        
    }];
}

/**
 删除全部数据
 
 @param state 是否成功
 */
- (void)deleteTabelAllState:(void (^)(BOOL state))state;
{
    [self.globalHelper deleteWithClass:[TBMakingListMode class] where:nil callback:^(BOOL result) {
        
        state(result);
    }];
}
#pragma mark -- 数据处理 --

- (void)makingTransformation:(NSArray <TBMakingListMode *>*)modes results:(void (^)(NSArray <TBMakingListMode *>*))results failure:(void (^)(NSError *error))failure;
{
    [self.listArray removeAllObjects];
    
    __weak typeof(self) weekSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [modes enumerateObjectsUsingBlock:^(TBMakingListMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [weekSelf.listArray addObject:[weekSelf transformation:obj]];
            
        }];

        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新
            if (weekSelf.listArray.count == modes.count )
            {
                if (results) {
                    
                    results(self.listArray);
                }
            }
            else
            {
                NSError *serializationError = nil;
                if (failure)
                {
                    failure(serializationError);
                }
            }

        });
    });
    
}

/**
 过滤模型中的不合法数据类型

 @param list 模型
 @return 模型
 */
- (TBMakingListMode *)transformation:(TBMakingListMode *)list
{
   
     [self escapeArray:list.appearancePhotos];
     [self escapeArray:list.foodPhotos];
     [self escapeArray:list.environmentPhotos];
     [self escapeArray:list.images];
     [self povertyescapeArray:list.povertyPhotoArray];
     [self escapeArray:list.signingArray];
     [self roomEscapeArray:list.roomDatas];
   
    return list;
}
//民宿数据转义
- (void)roomEscapeArray:(NSMutableArray *)array
{
        for (int k = 0; k<array.count; k++) {
            NSDictionary *obj = array[k];
            NSMutableArray *images = [[obj valueForKey:@"img"] mutableCopy];
            for (int i = 0; i<images.count; i++)
            {
                id data = images[i];
                if ([data isKindOfClass:[UIImage class]])
                {
                    [images replaceObjectAtIndex:i withObject:[self operationData:data]];
                }
            }
            NSDictionary *dictionary = @{@"img":images.copy,
                                         @"type":[obj valueForKey:@"type"],
                                         @"price":[obj valueForKey:@"price"],
                                         @"number":[obj valueForKey:@"number"]};
            [array replaceObjectAtIndex:k withObject:dictionary];
        }
}
// 扶贫转数据
- (void)povertyescapeArray:(NSMutableArray *)array
{

    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        id positive = [obj valueForKey:@"img1"];
        id reverse = [obj valueForKey:@"img2"];
        NSString *name = [obj valueForKey:@"name"];
        
        if ([positive isKindOfClass:[UIImage class]])
        {
            positive = [self operationData:positive];
        }
        if ([reverse isKindOfClass:[UIImage class]])
        {
            reverse = [self operationData:reverse];
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              name, @"name",
                              positive, @"img1",
                              reverse, @"img2",
                              nil];
        [array replaceObjectAtIndex:idx withObject:dic];

    }];
}
// 转义
- (void )escapeArray:(NSMutableArray *)array
{
    if (array.count >0&& array!=nil)
    {
        __weak typeof(self) weekSelf = self;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (![obj isKindOfClass:[NSString class]])
            {
                [array replaceObjectAtIndex:idx withObject:[weekSelf operationData:obj]];
            }
        }];
    }
}
/**
 将类型转为字符串

 @param obj 对象
 @return NSString
 */
- (NSString *)operationData:(id _Nonnull)obj;
{
    NSString *base64EncodedImage = @"";
    if ([obj isKindOfClass:[NSData class]])
    {
        NSData *data = obj;
        base64EncodedImage = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    else if ([obj isKindOfClass:[UIImage class]])
    {
        base64EncodedImage = [UIImageJPEGRepresentation(obj, 1.0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    return base64EncodedImage;
}
@end
