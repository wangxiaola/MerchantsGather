//
//  TBRoomEditorViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/11/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"

/**
 客房信息编辑
 */
@interface TBRoomEditorViewController : TBBaseViewController

/**
 修改数据

 @param data 数据
 @param row 索引
 */
- (void)editorData:(NSDictionary *)data indexRow:(NSInteger)row;

/**
 更新TableView
 */
@property (nonatomic, copy) void(^updataTableView)(NSDictionary *data, NSInteger index);
@end
