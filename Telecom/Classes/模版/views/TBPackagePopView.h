//
//  TBPackagePopView.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBPackageData;

/**
 套餐弹出
 */
@interface TBPackagePopView : UIView


typedef void(^selectSuccessful) (TBPackageData *mode);

@property (nonatomic, copy) selectSuccessful successful;

// 弹出选择框
- (void)showPackageData:(NSArray <TBPackageData *> *)arrat selectData:(selectSuccessful)selectData;

@end
