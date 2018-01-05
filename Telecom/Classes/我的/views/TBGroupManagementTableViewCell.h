//
//  TBGroupManagementTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/11.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBDiscountCouponMode;

@protocol TBGroupManagementTableViewCellDelegate <NSObject>
@optional

/**
 查看详情

 @param list 数据
 */
- (void)checkTheDetailsData:(TBDiscountCouponMode *)list;

/**
 编辑修改

 @param list 数据
 */
- (void)editData:(TBDiscountCouponMode *)list;

/**
 删除活动

 @param list 数据
 */
- (void)deleteActivitiesData:(TBDiscountCouponMode *)list;

/**
 分享活动

 @param list 数据
 */
- (void)sharingActivitiesData:(TBDiscountCouponMode *)list;

/**
 购买记录

 @param list 数据
 */
- (void)purchaseRecordsData:(TBDiscountCouponMode *)list;
@end
@interface TBGroupManagementTableViewCell : UITableViewCell

//是否可以分享
- (void)updateMode:(TBDiscountCouponMode*)couponList share:(BOOL)share;

@property (nonatomic, assign)id<TBGroupManagementTableViewCellDelegate>delegate;

@end
