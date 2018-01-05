//
//  TBLogInViewController.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/2.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBLogInViewController.h"
#import "TBVerifyViewController.h"
#import "TBRegisteredViewController.h"
#import "ZKTextField.h"
#import "TBTabBarController.h"
#import "NSString+MD5Addition.h"
#import "TBStartPageView.h"

@interface TBLogInViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet ZKTextField *accountTextField;
@property (weak, nonatomic) IBOutlet ZKTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation TBLogInViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 判断是否是第一次登陆
    
    hudConfig();
    
    /*
     获取APP版本号，将版本号作为Key（比如Bool类型），存储在NSuserDefault中，初此安装打开时，key是不存在的，即进入引导页面，之后将此key保存起来（保证前面的判断不会再进入）app升级后，判断新版本号的key，发现没有，即显示新版本的引导页面，然后将Key保存起来，以此类推。
     */
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *xcodeAppVersion = [NSString stringWithFormat:@"%@%@",[infoDictionary valueForKey:@"CFBundleShortVersionString"],[infoDictionary valueForKey:@"CFBundleVersion"]];
    // 判断是否第一次进入或者是否刚升级完成
    BOOL isVersion = [ZKUtil obtainBoolForKey:xcodeAppVersion];
    
    if ([ZKUtil obtainBoolForKey:VALIDATION] && isVersion == YES)
    {
        UIStoryboard *board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [APPDELEGATE window].rootViewController = [board instantiateInitialViewController];
    }
    else
    {
        [self uiSetting];
        [ZKUtil saveBoolForKey:xcodeAppVersion valueBool:YES];
    }
    // 启动页加载
    if ([ZKUtil obtainBoolForKey:START_PAGE] == NO)
    {
        TBStartPageView *pageView = [[TBStartPageView alloc] init];
        [pageView show];
    }
}
/**
 控件设置
 */
- (void)uiSetting
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.loginButton.layer.cornerRadius = 4;
    
    UIImageView *accountImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_icon_name"]];
    accountImage.frame = CGRectMake(0, 0, 30, 30);
    accountImage.contentMode = UIViewContentModeCenter;
    
    self.accountTextField.leftView = accountImage;
    self.accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入账号"          attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:13 weight:0],}];
    self.accountTextField.returnKeyType = UIReturnKeyDone;
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.accountTextField.delegate = self;
    self.accountTextField.layer.cornerRadius = 6;
    self.accountTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.accountTextField.layer.borderWidth = 1;
    self.accountTextField.spacing = 30;
    self.accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountTextField.tintColor = [UIColor whiteColor];
    
    UIImageView *passwordImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_icon_password"]];
    passwordImage.frame=CGRectMake(0, 0, 30, 30);
    passwordImage.contentMode = UIViewContentModeCenter;
    
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码"          attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:13 weight:0],}];
    self.passwordTextField.leftView = passwordImage;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.delegate = self;
    self.passwordTextField.layer.cornerRadius = 6;
    self.passwordTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.passwordTextField.layer.borderWidth = 1;
    self.passwordTextField.spacing = 30;
    self.passwordTextField.tintColor = [UIColor whiteColor];
    
    NSString *tel = [UserInfo account].phone;
    if (tel.length>0)
    {
        self.accountTextField.text = tel;
    }
    
    /**测试账号***/
    //#ifdef DEBUG
    //    self.accountTextField.text = @"18202810115";
    //    self.passwordTextField.text = @"123456";
    //#endif
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----点击事件----

- (IBAction)logInClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (self.accountTextField.text.length>0&&self.passwordTextField.text.length>0)
    {
        [self postVerify];
    }
    else
    {
        hudShowError(@"账号或密码不能为空");
    }
    
}

- (IBAction)forgetClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 1000;
    
    if (tag == 0)
    {
        TBRegisteredViewController *vc = [[TBRegisteredViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        TBVerifyViewController *verifyContrlloer = [[TBVerifyViewController alloc] init];
        verifyContrlloer.viewControllerType = userSetPassword;
        [self.navigationController pushViewController:verifyContrlloer animated:YES];
    }
}
/**
 请求验证账户
 */
- (void)postVerify
{
    hudShowLoading(@"正在登录");
    NSMutableDictionary *dic = [NSMutableDictionary params];
    [dic setValue:self.accountTextField.text forKey:@"phone"];
    [dic setValue:[self.passwordTextField.text stringFromMD5] forKey:@"pwd"];
    [dic setValue:@"170" forKey:@"interfaceId"];
    
    [ZKPostHttp post:@"" params:dic success:^(id responseObj)
     {
         NSString *errcode = [responseObj valueForKey:@"errcode"];
         NSString *errmsg = [responseObj valueForKey:@"errmsg"];
         
         if ([errcode isEqualToString:@"00000"])
         {
             NSDictionary *data = [responseObj valueForKey:@"data"];
             NSString *domain = [data valueForKey:@"domain"];
             if (domain.length == 0)
             {
                 hudShowError(@"当前账号所在区域建站不完整，请敬请期待。");
             }
             else
             {
                 [self logSuccessfullyData:data];
                 hudShowSuccess(@"登录成功");
             }
         }
         else
         {
             hudShowError(errmsg);
         }
         
     } failure:^(NSError *error)
     {
         
         hudShowError(@"网络出错了");
     }];
    
}

- (void)logSuccessfullyData:(NSDictionary*)data
{
    [ZKUtil saveBoolForKey:VALIDATION valueBool:YES];
    UserInfo *info = [[UserInfo alloc] init];
    info =  [UserInfo mj_objectWithKeyValues:data];
    [UserInfo saveAccount:info];
    
    UIStoryboard *board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [APPDELEGATE window].rootViewController = [board instantiateInitialViewController];
}

#pragma mark  -- UITextFieldDelegate ---
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self.view endEditing:YES];
    return YES;
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
