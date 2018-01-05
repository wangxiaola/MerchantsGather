//
//  TBTabBarController.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/2.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTabBarController.h"


@interface TBTabBarController ()

@end

@implementation TBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAppearance];
    self.delegate = self;
    

}
-(void)initAppearance{
    
    //搜索取消字体颜色
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIColor grayColor],NSShadowAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],NSShadowAttributeName,nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIColor grayColor],NSShadowAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],NSShadowAttributeName,nil] forState:UIControlStateHighlighted];
    
    self.tabBar.tintColor = NAVIGATION_COLOR;
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:NAVIGATION_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateSelected];
    self.tabBar.translucent = NO;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
