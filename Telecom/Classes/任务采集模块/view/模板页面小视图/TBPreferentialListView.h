//
//  TBPreferentialListView.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/8.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 优惠view类型

 - PreferentialListTypeAmount: 金额
 - PreferentialListTypeNumber: 数量
 - PreferentialListTypeRules: 规则
 - PreferentialListTypeLimit: 期限
 */
typedef NS_ENUM(NSInteger,PreferentialListType ) {

    PreferentialListTypeAmount = 0,
    PreferentialListTypeNumber,
    PreferentialListTypeRules,
    PreferentialListTypeLimit
};

#import <UIKit/UIKit.h>

@protocol TBPreferentialListViewDelegate <NSObject>
@optional
//发放金额
- (void)theAmountSize:(NSDictionary *__nonnull)amount;
//发放数量
- (void)theNumberOf:(NSString *__nonnull)number;
//使用规则
- (void)usingRulesAmount:(NSString *__nonnull)rules;
//使用期限
- (void)usingPeriodOfTime:(NSString *__nonnull)time;

@end

@interface TBPreferentialListView : UIView

/**
 创建小控件

 @param type 类型
 @param card 是否打折卡
 @return view
 */
- (instancetype __nonnull )initPreferentialType:(PreferentialListType)type isCard:(BOOL)card;

/**
 更新赋值

 @param data 数据
 @param type 类型
 */
- (void)updataViewList:(id  __nonnull )data PreferentialType:(PreferentialListType)type;

@property (nonatomic, assign,nonnull) id<TBPreferentialListViewDelegate>delegate;
// 第一次赋值 
- (void)updataStartTime:(NSString *__nonnull)startTime endTime:(NSString *__nonnull)endTime;

@end
