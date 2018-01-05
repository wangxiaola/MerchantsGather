//
//  TBTaskMakeBaseViewViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/11/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 模板编辑状态
 
 - TemplateProductionNewAdded: 新添加
 - TemplateProductionMaking: 制作
 - TBMakingProductionModifyThe: 编辑
 */
typedef NS_ENUM(NSInteger ,TBMakingProductionType) {
    
    TBMakingProductionNewAdded = 0,
    
    TBMakingProductionMaking,
    
    TBMakingProductionModifyThe,
    
    
};
#import "TBBaseViewController.h"
#import "TBMakingListMode.h"

/**
 任务制作基础类
 */
@interface TBTaskMakeBaseViewViewController : TBBaseViewController

// 商户ID
@property (nonatomic, assign) NSInteger merchantsID;
// 模板ID
@property (nonatomic, assign) NSInteger modelsID;
// 类型ID
@property (nonatomic, assign) NSInteger typeID;
// 类型
@property (nonatomic, strong) NSString *type;
/**
 模型数据
 */
@property (nonatomic, strong) TBMakingListMode *makingList;

@property (nonatomic) TBMakingProductionType templateType;

/**
 数据状态发生更改
 */
@property (nonatomic, copy) void(^dataStatusChange)(void);

@end
