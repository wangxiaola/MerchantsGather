//
//  ZKNavigationController.m
//  guide
//
//  Created by 汤亮 on 15/10/6.
//  Copyright © 2015年 daqsoft. All rights reserved.
//

#import "ZKNavigationController.h"
#import "UIBarButtonItem+Custom.h"

@interface ZKNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ZKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:NAVIGATION_COLOR];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [bar setTitleTextAttributes:attrs];
    [bar setTintColor:[UIColor whiteColor]];
    
    bar.barStyle = UIBarStyleBlack;

}
#pragma mark  --UIViewController--
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem setRitWithTitel:@"返回" itemWithIcon:@"nav_back" target:self action:@selector(back)];
    }

    [super pushViewController:viewController animated:animated];
}
#pragma mark --UIGestureRecognizer---
// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
     UIViewController *vc = self.viewControllers.lastObject;
    if (self.childViewControllers.count == 1
        ||[vc isKindOfClass:[NSClassFromString(@"TBTemplateCompleteViewController") class]]
        ||[vc isKindOfClass:[NSClassFromString(@"TBTaskMakeViewController") class]]
        ||[vc isKindOfClass:[NSClassFromString(@"TBClipVideoViewController") class]]) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}
#pragma mark ------
- (void)back
{
    [self popViewControllerAnimated:YES];
}
- (void)handleNavigationTransition:(UIPanGestureRecognizer *)zer
{
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
