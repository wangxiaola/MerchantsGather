//
//  TBReviewTipsPopView.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/28.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBReviewTipsPopView : UIView

/**
 赋值

 @param title 名称
 @param time 时间
 @param info 内容
 */
- (void)showViewTitle:(NSString *)title time:(NSString *)time content:(NSString *)info;

@end
