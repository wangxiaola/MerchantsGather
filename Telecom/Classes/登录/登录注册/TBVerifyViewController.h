//
//  TBVerifyViewController.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/2.
//  Copyright © 2016年 王小腊. All rights reserved.
//

/**
 用户进入状态类型

 - userVerify: 商户注册
 - userSetPassword: 用户设置密码
 */
typedef NS_ENUM(NSInteger, userType)
{
    userVerify = 0,
    userSetPassword

};
#import <UIKit/UIKit.h>

/**
 验证
 */
@interface TBVerifyViewController : UIViewController

/**
 显示状态
 */
@property (nonatomic) userType viewControllerType;

@end
