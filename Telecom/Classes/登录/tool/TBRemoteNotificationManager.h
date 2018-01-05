//
//  TBRemoteNotificationManager.h
//  Telecom
//
//  Created by 王小腊 on 2017/9/4.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBRemoteNotificationManager : NSObject
/**
 *  APP未启动时，打开APP处理通知消息
 *  当通过点击通知打开APP则跳转到相关页面，否则不做任何处理
 *
 *  @param launchOptions 通知相关内容，可能为nil
 */
+ (void)handleRemoteNotificationWhenApplicationLaunched:(NSDictionary *)launchOptions;

/**
 *  当APP处于后台或正在活动状态，接收到通知时处理通知消息
 *  当APP从后台进入则跳转到相关页面，当APP处于活动状态时弹框是否要查看通知
 *  @param userInfo 通知相关内容
 */
+ (void)handleRemoteNotificationWhenRecievingRemoteNotification:(NSDictionary *)userInfo;
@end
