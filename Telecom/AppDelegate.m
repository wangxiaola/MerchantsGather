//
//  AppDelegate.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/2.
//  Copyright © 2016年 王小腊. All rights reserved.
//

//  通知配置
static NSString *appKey = @"44d55597da359aede0632f64";
static NSString *channel = @"Publish channel";

#ifdef DEBUG
static BOOL isProduction = NO;
#else
static BOOL isProduction = YES;
#endif

#import "AFNetworking.h"
#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "TBUpdateTooltipView.h"
#import "WXApi.h"
#import "ZKNavigationController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TBRemoteNotificationManager.h"
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<WXApiDelegate,CLLocationManagerDelegate,JPUSHRegisterDelegate>
@property(nonatomic) CLLocationManager *locationManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    // 初始化微信
    [self initSDK];
    [self startWebView];
    [self checkVersion];
    // 初始化jpush
    [self setupJPush:launchOptions];
    
    ZKNavigationController *nav = [[ZKNavigationController alloc] initWithRootViewController:[NSClassFromString(@"TBLogInViewController") new]];
    self.window.rootViewController = nav;
    //设置电池烂颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
// 初始化JPush
- (void)setupJPush:(NSDictionary *)launchOptions
{
    /** 极光 **/
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else  {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    [JPUSHService setLogOFF];
#pragma mark -- 崩溃日志
    [JPUSHService crashLogON];
}
-(void)initSDK
{
    [WXApi registerApp:weixinID enableMTA:YES];
    // 设置键盘监听管理
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    [keyboardManager setEnable:YES];
    [keyboardManager setKeyboardDistanceFromTextField:0];
    [keyboardManager setEnableAutoToolbar:YES];
    [keyboardManager setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [keyboardManager setPlaceholderFont:[UIFont systemFontOfSize:14]];
    [keyboardManager setShouldResignOnTouchOutside:YES];
    [keyboardManager setToolbarTintColor:NAVIGATION_COLOR];
    //设置为文字
    [keyboardManager setToolbarDoneBarButtonItemText:@"完成"];
    [AMapServices sharedServices].apiKey = GDMAP_KEY;
    // 开启定位权限
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // 开启语音权限
    AVAudioSession *audioSession = [[AVAudioSession alloc]init];
    
    [audioSession requestRecordPermission:^(BOOL granted) {
        
    }];
}

/**
 *  设置web信息
 */
- (void)startWebView
{
    UIWebView *web = [[UIWebView alloc] init];
    NSString *userAgent = [web stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *appName = NSLocalizedStringFromTable(@"daqsoft.com", @"InfoPlist", nil);
    NSString *customUserAgent = [userAgent stringByAppendingFormat:@" %@/%@", appName, version];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
    [web removeFromSuperview];
    web = nil;
}
-(void)checkVersion{
    //版本更新
    [self versionInformationQuery];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSNotification * notice = [NSNotification notificationWithName:@"VoiceStopNotice" object:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    MMLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark ---WXApiDelegate---
//onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
-(void) onReq:(BaseReq*)req;

{
    
}
//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
-(void) onResp:(BaseResp*)resp;
{
    
}
#pragma mark  --CLLocationManager--
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
                [self.locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
                [self.locationManager requestAlwaysAuthorization];
                
            }
            break;
        default:
            break;
            
    }
}

/**
 更新查询
 */
- (void)versionInformationQuery
{
    NSString *appItunesUrlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",TELECOM_ID];
    NSURL *urlS = [NSURL URLWithString:appItunesUrlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (data.length > 0) {
            //有返回数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:Nil];
            
            NSArray *results = [dic objectForKey:@"results"];
            
            if (results.count >0)
            {
                //appStore 版本
                NSString *newVersion = [[[dic objectForKey:@"results"] objectAtIndex:0]objectForKey:@"version"];
                NSString *updateContent = [NSString stringWithFormat:@"更新说明: %@",[[[dic objectForKey:@"results"] objectAtIndex:0]objectForKey:@"releaseNotes"]];
                //本地版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                
                if (newVersion && ([newVersion compare:currentVersion] == 1))
                {
                    TBUpdateTooltipView *updataView = [[TBUpdateTooltipView alloc] initShowPrompt:updateContent];
                    [updataView show];
                    
                    
                }
            }
            
        }
        
    }];
    
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self messageProcessingData:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler;
{
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self messageProcessingData:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [self messageProcessingData:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    
    [self messageProcessingData:userInfo];
}

/**
 从后台到前台
 
 @param application application
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // 清除图标数字
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}
- (void)messageProcessingData:(NSDictionary *)userInfo
{
    // 处理通知消息
    [JPUSHService handleRemoteNotification:userInfo];
    UIViewController *topmostVC = [ZKUtil getCurrentVC];
    
    // 如果是任务制作页和任务查看页就不做处理
    if ([(AppDelegate *)APPDELEGATE isProcessingNotice] == NO)
    {
        // 点击消息后的事件
        [TBRemoteNotificationManager handleRemoteNotificationWhenRecievingRemoteNotification:userInfo];
    }
    // 如果当前显示页面是任务查看页面就通知刷新任务数据
    else if ([topmostVC isKindOfClass:NSClassFromString(@"TBTaskListViewController")])
    {
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:TaskToInform object:nil];
        //发送消息
        [[NSNotificationCenter defaultCenter] postNotification:notice];
    }
}

@end
