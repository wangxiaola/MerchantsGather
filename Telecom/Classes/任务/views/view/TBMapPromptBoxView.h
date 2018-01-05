//
//  TBMapPromptBoxView.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/6.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 提示框
 */
@interface TBMapPromptBoxView : UIView

/**
 初始化创建

 @param words 提示信息
 @return view
 */
- (instancetype)initMarkedWords:(NSString*)words;

/**
 弹出
 */
- (void)show;

/**
 消失
 */
- (void)disappear;
@end
