//
//  TBMyBusinessTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/1/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBHomeDataMode.h"

@protocol TBMyBusinessTableViewCellDelegate <NSObject>
@optional
/**
 点击编辑

 @param data 数据
 */
- (void)businessCellClickEditorMode:(TBHomeShopsRoot *)data;

/**
 点击分享

 @param data 数据
 */
- (void)businessCellClickShareMode:(TBHomeShopsRoot *)data;

@end

extern NSString *const TBMyBusinessTableViewCellID;

@interface TBMyBusinessTableViewCell : UITableViewCell


- (void)cellUIAssignmentMode:(TBHomeShopsRoot *)mode showShare:(BOOL)show;

@property (nonatomic, assign) id<TBMyBusinessTableViewCellDelegate>delegate;

@end
