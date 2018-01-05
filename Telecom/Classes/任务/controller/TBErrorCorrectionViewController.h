//
//  TBErrorCorrectionViewController.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/8.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"
@class TBTaskListRoot;
/**
 商家纠错
 */
@interface TBErrorCorrectionViewController : TBBaseViewController

@property (nonatomic, strong) TBTaskListRoot *errorData;
// 更新
@property (nonatomic, copy) void(^updata)(void);

@end
