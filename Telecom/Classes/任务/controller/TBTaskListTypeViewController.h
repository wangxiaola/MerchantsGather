//
//  TBTaskListTypeViewController.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/8.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBBaseTableViewController.h"
#import "TBTaskListTableViewCell.h"

@interface TBTaskListTypeViewController : TBBaseTableViewController

- (instancetype)initType:(Tasktype)type;

/**
 搜索请求

 @param key key
 @param code code
 */
- (void)requestDataSearch:(NSString*)key searchCode:(NSString *)code;


@end
