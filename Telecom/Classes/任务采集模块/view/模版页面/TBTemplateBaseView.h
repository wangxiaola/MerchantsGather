//
//  TBTemplateBaseView.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/9.
//  Copyright © 2016年 王小腊. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TBMakingListMode.h"


@interface TBTemplateBaseView : UIView

/**
 内容view
 */
@property (nonatomic, strong) UIView *contenView;

@property (nonatomic, strong) TBMakingListMode *makingList;

#pragma mark  ----子类继承方法----
/**
 子视图开始添加
 */
- (void)createAview;
/**
 数据更新

 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;

/**
 数据提交

 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;

@end
