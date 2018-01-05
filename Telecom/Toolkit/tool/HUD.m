//
//  HUD.m
//  TrainOnline
//
//  Created by tangliang on 16/10/24.
//  Copyright © 2016年 daqsoft. All rights reserved.
//

#import "HUD.h"
@import SVProgressHUD;

void hudConfig()
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    //HUD背景色
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //动画样式
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    //动画时间
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    
    [SVProgressHUD setMaxSupportedWindowLevel:1.5];
}

void hudShowLoading(NSString *msg)
{
    [SVProgressHUD showWithStatus:msg];
}

void hudShowSuccess(NSString *msg)
{
    [SVProgressHUD showSuccessWithStatus:msg];
}

void hudShowError(NSString *msg)
{
    [SVProgressHUD showErrorWithStatus:msg];
}

void hudShowFailure()
{
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

void hudShowInfo(NSString *msg)
{
    [SVProgressHUD showInfoWithStatus:msg];
}
void hudDismiss()
{
    [SVProgressHUD dismiss];
}


