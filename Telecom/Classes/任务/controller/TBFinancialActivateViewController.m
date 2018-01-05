//
//  TBFinancialActivateViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/6/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBFinancialActivateViewController.h"

@interface TBFinancialActivateViewController ()


@end

@implementation TBFinancialActivateViewController
/**
 初始化
 
 @param phone 电话
 @return self
 */
- (instancetype)initMerchantsPhone:(NSString *)phone;
{
    if (self = [super init])
    {
        NSString *timeStamp = [ZKUtil timeStamp];
        self.urlString = [NSString stringWithFormat:@"%@?interfaceId=260&AppId=2zPhtu3ittzt&AppKey=e22eb607c64b4df5a676ffc1274300a3&TimeStamp=%@&phone=%@",POST_URL,timeStamp,phone];
    }
    return self;
}
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    NSString *url =  webView.request.URL.absoluteString;
    if (([url containsString:@"http://myshop.weixin.geeker.com.cn/"] &&
         ![url containsString:@"bind.wap"])
        ||
        ([url containsString:@"close.html"]
        && [url containsString:@"https://ebank.cgnb.cn:8091"]))
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
