//
//  TBLBXScanViewController.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/9.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBLBXScanViewController.h"
#import "TBMoreReminderView.h"
@interface TBLBXScanViewController ()

@end

@implementation TBLBXScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationInterface];
}
#pragma mark  ----配置界面----
- (void)configurationInterface
{
    self.navigationItem.title = @"扫码绑定";
    self.isNeedScanImage    = YES;
    self.isOpenInterestRect  = YES;
    
    LBXScanViewStyle *style  = [[LBXScanViewStyle alloc] init];
    style.isNeedShowRetangle = YES;
    style.centerUpOffset     = 0;
    style.colorRetangleLine  = NAVIGATION_COLOR;
    style.anmiationStyle     = LBXScanViewAnimationStyle_LineMove;
    style.animationImage     = [UIImage imageNamed:@"lb_scanLin"];
    self.style               = style;
    
    [self reStartDevice];
}

#pragma mark -实现类继承该方法，作出对应处理
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    [self.scanObj stopScan];// 停止扫码
    
    LBXScanResult *result = array.firstObject;
    NSString *url = result.strScanned;
    
    if ([url containsString:@"https://wx.cq.abchina.com/qc/q"]) {
        
        NSString *code = [url componentsSeparatedByString:@"?"].lastObject;
        if (code) {
            
            [self postDataParameterCode:code];
        }
        else
        {
            [self showHUDError:@"二维码错误"];
        }
    }
    else
    {
        [self showHUDError:@"二维码错误"];
    }

}
#pragma mark  ----数据请求----

/**
 数据请求

 @param code 参数
 */
- (void)postDataParameterCode:(NSString *)code
{
    NSMutableDictionary *dic = [NSMutableDictionary params];
    [dic setValue:code forKey:@"card"];
    [dic setValue:@"296" forKey:@"interfaceId"];
    [dic setValue:[NSNumber numberWithInteger:self.shopID] forKey:@"shopid"];
    hudShowLoading(@"正在请求");
    TBWeakSelf
    [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
        
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        
        if ([errcode isEqualToString:@"00000"]) {
            
            NSDictionary *data = [[responseObj valueForKey:@"data"] mj_JSONObject];
            NSString *msg      = [data valueForKey:@"msg"];
            [weakSelf showPromptInformationData:msg];
        }
        else
        {
            [weakSelf showHUDError:@"网络异常"];
        }
        
    } failure:^(NSError *error) {
        [weakSelf showHUDError:@"网络异常"];
    }];
}
- (void)showPromptInformationData:(NSString *)data
{
    hudDismiss();
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:data];
    TBWeakSelf
    [more showHandler:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [more cancelClick:^{
        [weakSelf reStartDevice];
    }];
}
- (void)showHUDError:(NSString *)str
{
    hudShowError(str);
    [self reStartDevice];
}
//子类继承必须实现的提示
/**
 *  继承者实现的alert提示功能：如没有权限时会调用
 *
 *  @param str 提示语
 */
- (void)showError:(NSString*)str;
{
    [UIView addMJNotifierWithText:str dismissAutomatically:YES];
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
