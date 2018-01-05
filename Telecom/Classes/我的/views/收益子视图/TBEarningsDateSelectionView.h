//
//  TBEarningsDateSelectionView.h
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 收益日期选择弹出框
 */
@interface TBEarningsDateSelectionView : UIView

- (void)show;

/**
 选择时间后的回调
 */
@property (nonatomic, copy) void (^selectionDate)(NSString *date);

@end
