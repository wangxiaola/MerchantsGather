//
//  UIViewController+Prompt.h
//  slyjg
//
//  Created by 汤亮 on 16/4/20.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Prompt)

/**
 *  弹出错误提示框
 */
- (void)showErrorAlertWithTitle:(NSString *)title description:(NSString *)description;

@end
