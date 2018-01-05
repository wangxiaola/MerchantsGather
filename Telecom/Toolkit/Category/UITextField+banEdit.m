//
//  UITextField+banEdit.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "UITextField+banEdit.h"

@implementation UITextField (banEdit)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;  
}

@end
