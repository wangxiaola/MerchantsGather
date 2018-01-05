//
//  AppDelegate.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/2.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 是否处理通知 yes 不    no 要
 */
@property (assign, nonatomic) BOOL isProcessingNotice;
@end

