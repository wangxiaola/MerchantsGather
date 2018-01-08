//
//  TBGroupSpecificationView.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/13.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^infoViewHeight)(CGFloat viewHeight);
/**
 团购说明
 */
@interface TBGroupSpecificationView : UIView
//最大数量
@property (nonatomic, assign) NSInteger maxNumber;

@property (nonatomic, copy)infoViewHeight viewHeight;

/**
 更新布局

 @param height 高度
 */
- (void)updataViewHeight:(infoViewHeight)height;
/**
 更新布局显示

 @param infoArray 数据
 */
- (void)updataInfoArray:(NSArray *)infoArray;
/**
 新添加

 @param number 数量
 */
- (void)addInfoCellNumber:(NSInteger)number ;

/**
 获取介绍数据

 @return 数组
 */
- (NSArray *)accessToIntroduceData;
@end
