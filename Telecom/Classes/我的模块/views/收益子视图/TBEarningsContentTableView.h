//
//  TBEarningsContentTableView.h
//  Telecom
//
//  Created by 王小腊 on 2017/8/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBEarningsHeaderView.h"
#import "TBEarningsFooterView.h"

@interface TBEarningsContentTableView : UITableView
/**
 更新数据

 @param rootClass 数组
 */
- (void)updataTableViewData:(NSArray *)rootClass;

/**
 更新数据
 */
@property (nonatomic, copy) void(^requestData)(void);

@end
