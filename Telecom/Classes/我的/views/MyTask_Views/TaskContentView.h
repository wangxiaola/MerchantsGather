//
//  TaskContentView.h
//  Telecom
//
//  Created by zhangxingdong 张兴栋 on 16/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ProgressBlock)(CGFloat progess,NSInteger index);

@protocol TaskContentViewDelegate <NSObject>

@optional

- (UIViewController *)selectViewController_And_For_indexpath:(NSInteger)index;

@end


@interface TaskContentView : UIView

@property (nonatomic, assign) UIViewController <TaskContentViewDelegate>* delegate;

@property (nonatomic, strong) ProgressBlock progressBLK;



// 设置点击偏移的距离

- (void)setTheOffsetDistance:(CGPoint)pointOffset animationd:(BOOL)animated;


@end
