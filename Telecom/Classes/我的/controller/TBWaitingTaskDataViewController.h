//
//  TBWaitingTaskDataViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"

/**
 待提交任务
 */
@interface TBWaitingTaskDataViewController : TBBaseViewController

/**
 完成所有填写的任务  0不完整
 */
@property (nonatomic, assign) BOOL complete;

@end
