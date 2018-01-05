//
//  TBTaskMakeViewMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBMakingListMode;

@protocol TBTaskMakeViewModeDelegate <NSObject>
@optional

/**
 开始请求
 */
- (void)postDataStart;
/**
 制作数据获取

 @param data data
 */
- (void)makingTemplateData:(TBMakingListMode *)data;

/**
  编辑数据获取

 @param data data
 */
- (void)editTemplateData:(TBMakingListMode *)data;

/**
 数据请求失败

 @param err string
 */
- (void)dataPostError:(NSString *)err;

@end
/**
 任务数据处理
 */
@interface TBTaskMakeViewMode : NSObject

@property (nonatomic, assign) id<TBTaskMakeViewModeDelegate>delegate;

typedef void(^successful) (TBMakingListMode *mode);
typedef void(^failure)(void);

typedef void(^isSaveState)(BOOL state);

@property (nonatomic, assign) BOOL hiddeHUD;

@property (nonatomic, copy) successful successful_s;
@property (nonatomic, copy) isSaveState saveState;
@property (nonatomic, copy) failure failure_f;

/**
 模型
 */
@property (nonatomic, strong) TBMakingListMode *makingMode;
/**
 是否新名称 yes
 */
@property (nonatomic, assign) BOOL nameState;

- (void)postMakingDataID:(NSInteger)_id;

- (void)postEditDataID:(NSInteger)_id;

// 其它类型上传
- (void)submitDataSuccessful:(successful)successful failure:(failure)failure;
// 服务场所上传
- (void)submitServiceSuccessful:(successful)successful failure:(failure)failure;

/**
 保存
 @param state 状态
 */
- (void)saveState:(isSaveState)state;

- (void)deleteMode:(TBMakingListMode *)mode state:(void(^)(BOOL successful))successful;

@end
