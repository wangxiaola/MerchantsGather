//
//  TBTaskMakeFootView.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBTaskMakeFootViewDelegate <NSObject>

/**
 尾部视图点击代理

 @param type 左右点击类型 yes左点击
 */
- (void)footViewTouchUpInsideType:(BOOL)type;

/**
 保存
 */
- (void)footViewTouchUpInsideSave;

@end
@interface TBTaskMakeFootView : UIView


@property (nonatomic, assign) id<TBTaskMakeFootViewDelegate>delegate;

@property (nonatomic, assign) NSInteger maxPage;

- (void)updateFootViewStyle:(NSInteger)index;

@end
