//
//  TBBusinessTypeTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

extern NSString *const TBBusinessTypeTableViewCellID;

#import <UIKit/UIKit.h>
@class TBTaskListRoot;

@interface TBBusinessTypeTableViewCell : UITableViewCell

@property (nonatomic, assign) id controller;


/**
 cell上的button点击  row == 0 制作
 */
@property (nonatomic, copy) void (^tableViewCellClick)(NSInteger row, TBTaskListRoot *root);

- (void)updateMode:(TBTaskListRoot*)list;
@end
