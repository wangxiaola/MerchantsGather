//
//  TBRemoteNotificationManager.m
//  Telecom
//
//  Created by 王小腊 on 2017/9/4.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBRemoteNotificationManager.h"
#import "TBTabBarController.h"
@implementation TBRemoteNotificationManager
+ (void)handleRemoteNotificationWhenApplicationLaunched:(NSDictionary *)launchOptions
{
    if (!launchOptions && [UserInfo account].phone.length == 0) return;
    
    TBTabBarController *departmentTabBarVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    UIApplication.sharedApplication.keyWindow.rootViewController = departmentTabBarVc;
    
    [self pushSpecifiedController:departmentTabBarVc];
}

+ (void)handleRemoteNotificationWhenRecievingRemoteNotification:(NSDictionary *)userInfo
{
    
    
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive) return;
    
    UITabBarController *departmentTabBarVc = self.currentDisplayingViewController.tabBarController;
    if (![departmentTabBarVc isKindOfClass:NSClassFromString(@"TBTabBarController")]) {
        departmentTabBarVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        UIApplication.sharedApplication.keyWindow.rootViewController = departmentTabBarVc;
    }
    
    [self pushSpecifiedController:departmentTabBarVc];
    
}
+ (void)pushSpecifiedController:(UITabBarController *)departmentTabBarVc
{
    departmentTabBarVc.selectedIndex = 0;
    UINavigationController *controller = departmentTabBarVc.customizableViewControllers[0];
    [controller.visibleViewController.navigationController pushViewController:[NSClassFromString(@"TBTaskListViewController") alloc] animated:NO];
}
+ (UIViewController *)currentDisplayingViewController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    id  nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    UIViewController *result = nil;
    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)nextResponder;
        UINavigationController *nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result = nav.childViewControllers.lastObject;
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]) {
        UIViewController *nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else {
        result = nextResponder;
    }
    
    return result;
}

@end
