//
//  TBEarningsContentView.h
//  Telecom
//
//  Created by 王小腊 on 2017/8/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TBTitleHeight 45
@interface TBEarningsContentView : UIView

/**
 更新数据
 
 @param postersNumber 收益
 @param date 时间
 */
- (void)updataPostersNumber:(CGFloat)postersNumber dateString:(NSString *)date;
/**
 选择时间后的回调
 */
@property (nonatomic, copy) void (^earningsSelectionDate)(NSString *date);
@end
