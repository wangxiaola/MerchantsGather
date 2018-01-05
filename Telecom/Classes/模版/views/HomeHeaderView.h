//
//  HomeHeaderView.h
//  Telecom
//
//  Created by zhangxingdong 张兴栋 on 16/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 获取点击的第几项 HeaderViewBlock */

typedef void (^HeaderViewBlock)(void);

@interface HomeHeaderView : UICollectionReusableView

@property (nonatomic, assign) NSInteger tool;

@property (nonatomic, strong) HeaderViewBlock headerIndexBlock;


@end
