//
//  TBTaskListTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.
//


extern NSString *const TBTaskListTableViewCellID;

/**
 任务类型
 
 - TasktypeThrough: 未开始
 - TasktypeNotThrough: 审核不通过
 - TasktypeToAudit: 待审核
 */
typedef NS_ENUM(NSInteger, Tasktype) {
    
    TasktypeThrough = 1,
    TasktypeNotThrough = 2,
    TasktypeToAudit = 3
};

#import <UIKit/UIKit.h>
@class TBTaskListRoot;

@protocol TBTaskListTableViewCellDelegate <NSObject>
@optional
/**
 点击编辑
 
 @param data 数据
 */
- (void)taskCellClickEditorMode:(TBTaskListRoot *)data;

/**
 点击审核详情
 
 @param data 数据
 */
- (void)taskCellClickDetailsMode:(TBTaskListRoot *)data;

/**
 点击营业状态
 
 @param data 数据
 */
- (void)taskCellClickBusinessMode:(TBTaskListRoot *)data;

/**
 点击分享
 
 @param data 数据
 */
- (void)taskCellClickShareMode:(TBTaskListRoot *)data;

/**
 点击激活

 @param data 数据
 */
- (void)taskCellClickActivationMode:(TBTaskListRoot *)data;

@end

@interface TBTaskListTableViewCell : UITableViewCell



@property (nonatomic, assign) id<TBTaskListTableViewCellDelegate>delegate;

- (void)updateMode:(TBTaskListRoot*)list share:(BOOL)share taskStatus:(Tasktype)state;



@end
