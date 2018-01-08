//
//  TitleLabel.h
//  Telecom
//
//  Created by zhangxingdong 张兴栋 on 16/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClicedBlock)(NSInteger index);

@interface TitleLabel : UIView

- (void)scroll_Progress:(CGFloat)progress ForIndex:(NSInteger)index;

@property (nonatomic, strong) ClicedBlock block;

@end
