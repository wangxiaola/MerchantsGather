//
//  UIViewController+Prompt.m
//  slyjg
//
//  Created by 汤亮 on 16/4/20.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "UIViewController+Prompt.h"

@implementation UIViewController (Prompt)

- (void)showErrorAlertWithTitle:(NSString *)title description:(NSString *)description
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:description preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
