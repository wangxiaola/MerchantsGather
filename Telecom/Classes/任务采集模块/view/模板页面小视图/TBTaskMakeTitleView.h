//
//  TBTaskMakeTitelView.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/17.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 名称
 */
@interface TBTaskMakeTitleView : UIView

/**
 名称字典数组
 */
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*titelArray;
/**
 选中第几个

 @param index row
 */
- (void)selectIndex:(NSInteger)index;

/**
 创建

 @param frame 尺寸
 @param type 类型
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame type:(NSString *)type;

@end
