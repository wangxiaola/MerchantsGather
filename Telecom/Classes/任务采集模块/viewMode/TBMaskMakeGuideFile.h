//
//  TBMaskMakeGuideFile.h
//  Telecom
//
//  Created by 王小腊 on 2018/1/5.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TBTemplateCompleteViewController.h"

#import "TBTaskListMode.h"
#import "TBMakingListMode.h"
#import "TBTaskMakeViewMode.h"

#import "TBTemplateBaseView.h"
#import "TBStrategyViewController.h"
#import "CDPMonitorKeyboard.h"
#import "UIBarButtonItem+Custom.h"
#import "TBMoreReminderView.h"
#import "TBTaskMakeFootView.h"
#import "TBTaskMakeTitleView.h"
#import "AFNetworkReachabilityManager.h"
#import "TBSaveSuccessTipsView.h"
#import "AppDelegate.h"

/**
 引导配置文件
 */
@interface TBMaskMakeGuideFile : NSObject


/**
  获取视图加载集合

 @param type 任务类型
 @return 视图集合
 */
+ (NSMutableArray *)obtainLoadCollectionTask:(NSString *)type;
@end
