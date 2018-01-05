//
//  TBVerifyViewController.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/2.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBVerifyViewController.h"
#import "ZKTextField.h"
#import "TBSetPasswordViewController.h"
#import "TBCountdownSingle.h"

@interface TBVerifyViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *securityButton;// 验证计时按钮
@property (nonatomic, strong) ZKTextField *phoneField;
@property (nonatomic, strong) ZKTextField *captchaField;

@property (nonatomic, strong) NSString *verification;//验证码
@end

@implementation TBVerifyViewController
@synthesize securityButton,phoneField,captchaField;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(245, 246, 247);
    self.title = @"手机验证";
    
    [self initViews];
    [self setDate];
}
#pragma mark --- 构图----
- (void)initViews
{
    UIView *phoneFieldView = [[UIView alloc] init];
    viewlayeSet(phoneFieldView);
    [self.view addSubview:phoneFieldView];
    
    UIView *captchaFieldView = [[UIView alloc] init];
    viewlayeSet(captchaFieldView);
    [self.view addSubview:captchaFieldView];
    
    phoneField = [[ZKTextField alloc] init];
    phoneField.placeholder = @"请输入您的手机号码";
    phoneField.tag = 1000;
    phoneField.delegate = self;
    textFieldSet(phoneField);
    [self.view addSubview:phoneField];
    phoneField.text = [UserInfo account].phone;
    
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = BODER_COLOR;
    [phoneFieldView addSubview:linView];
    
    securityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    securityButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [securityButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [securityButton setTitleColor:RGB(24, 196, 157) forState:UIControlStateNormal];
    [securityButton addTarget:self action:@selector(sendEvent:) forControlEvents:UIControlEventTouchUpInside];
    [phoneFieldView addSubview:securityButton];
    
    captchaField = [[ZKTextField alloc] init];
    captchaField.placeholder = @"请输入验证码";
    captchaField.delegate = self;
    textFieldSet(captchaField);
    [self.view addSubview:captchaField];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.backgroundColor = NAVIGATION_COLOR;
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 3;
    [sendButton setTitle:@"确 定" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:0.4];
    [sendButton addTarget:self action:@selector(captchaClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    /******* 布局 ********/
    
    [phoneFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(18+64);
        make.height.mas_equalTo(44);
    }];
    
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(1);
        make.right.mas_equalTo(phoneFieldView.mas_right).mas_equalTo(-80);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        
    }];
    
    [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(phoneFieldView.mas_left).mas_equalTo(8);
        make.right.mas_equalTo(linView.mas_left).mas_equalTo(-4);
        make.top.bottom.mas_equalTo(phoneFieldView);
    }];
    
    [securityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(linView.mas_right).mas_equalTo(0);
        make.right.mas_equalTo(phoneFieldView.mas_right).mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
    
    [captchaFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(phoneFieldView.mas_bottom).offset(8);
        make.height.mas_equalTo(44);
    }];
    
    [captchaField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(captchaFieldView.mas_left).mas_equalTo(8);
        make.right.mas_equalTo(captchaFieldView.mas_right).mas_equalTo(-4);
        make.top.bottom.mas_equalTo(captchaFieldView);
    }];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(captchaFieldView.mas_bottom).offset(18);
        make.height.mas_equalTo(44);
    }];
}


void viewlayeSet(UIView*view)
{
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 3;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = BODER_COLOR.CGColor;
}
void textFieldSet(ZKTextField*field)
{
    field.textColor = [UIColor grayColor];
    field.font = [UIFont systemFontOfSize:14];
    [field setValue:[UIFont boldSystemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    field.borderStyle = UITextBorderStyleNone;
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.returnKeyType = UIReturnKeyDone;
    
}

- (void)setDate
{
    int num ;
    
    if (self.viewControllerType == userVerify) {
        
        num = [TBCountdownSingle sharedInstance].verifyTimeNumber;
    }
    else
    {
        num = [TBCountdownSingle sharedInstance].setPasswordTimeNumber;
    }
    
    if (num > 0)
    {
        [self startTheDate:num];
    }
    
    self.verification = [ZKUtil getUserDataForKey:Verification_code];
    
}
#pragma mark  --- 点击事件 ---

- (IBAction)sendEvent:(UIButton*)sender
{
    
    if ([ZKUtil isMobileNumber:self.phoneField.text])
    {
        if (self.viewControllerType == userVerify) {
            
            [self verifyTheUniqueness];
        }else
        {
            [self sendVerificationCode];
        }
    }
    else
    {
        hudShowError(@"请输入正确的手机号码");
    }
}

/**
 验证唯一性
 */
- (void)verifyTheUniqueness
{
    hudShowLoading(@"手机号验证中");
    NSMutableDictionary *dic = [NSMutableDictionary params];
    [dic setValue:self.phoneField.text forKey:@"phone"];
    [dic setValue:@"230" forKey:@"interfaceId"];
    TBWeakSelf
    [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
        
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        NSString *errmsg = [responseObj valueForKey:@"errmsg"];
        if ([errcode isEqualToString:@"00000"])
        {
            BOOL data = [[responseObj valueForKey:@"data"] boolValue];
            if (data == NO)
            {
                [weakSelf sendVerificationCode];
            }
            else
            {
                hudShowError(@"手机号已注册");
            }
        }
        else
        {
            hudShowError(errmsg);
        }
        
    } failure:^(NSError *error) {
        hudShowError(@"网络出错了");
    }];

}
/**
 发送验证码
 */
- (void)sendVerificationCode
{
    [ZKUtil cacheUserValue:@"" key:Verification_code];
    [ZKUtil cacheUserValue:@"" key:Verification_phone];
    hudShowLoading(@"正在获取验证码");
    NSMutableDictionary *dic = [NSMutableDictionary params];
    [dic setValue:self.phoneField.text forKey:@"phone"];
    [dic setValue:@"2" forKey:@"shopid"];
    [dic setValue:@"171" forKey:@"interfaceId"];
    
    if (self.viewControllerType == userVerify)
    {
        [dic setObject:@"zhuce" forKey:@"type"];
    }
    
    TBWeakSelf
    [ZKPostHttp post:@"" params:dic success:^(id responseObj)
     {
         NSString *errcode = [responseObj valueForKey:@"errcode"];
         NSString *errmsg = [responseObj valueForKey:@"errmsg"];
         
         if ([errcode isEqualToString:@"00000"])
         {
             NSString *data = [responseObj valueForKey:@"data"];
             [weakSelf startTheDate:120];
             weakSelf.verification = data;
             [ZKUtil cacheUserValue:data key:Verification_code];
             [ZKUtil cacheUserValue:weakSelf.phoneField.text key:Verification_phone];
             [captchaField becomeFirstResponder];//自动弹出键盘
             hudShowSuccess(@"发送成功");
         }
         else
         {
             hudShowError(errmsg);
         }
         
     } failure:^(NSError *error) {
         
         hudShowError(@"网络出错了");
     }];
}
// 开始计时
- (void)startTheDate:(int)number
{
    BOOL state = self.viewControllerType == userVerify?YES:NO;
    [[TBCountdownSingle sharedInstance] setUser:state];
    TBWeakSelf
    [[TBCountdownSingle sharedInstance] startTheDatelength:number timeDate:^(NSString *numberString) {
        
        [weakSelf.securityButton setTitle:[NSString stringWithFormat:@"%@s",numberString] forState:UIControlStateNormal];
        weakSelf.securityButton.userInteractionEnabled = NO;
        
    } endTime:^{
        
        //设置界面的按钮显示 根据自己需求设置
        [weakSelf.securityButton setTitle:@"验证码" forState:UIControlStateNormal];
        weakSelf.securityButton.userInteractionEnabled = YES;
    }];
}
- (void)captchaClick
{
    [self.view endEditing:YES];
    
    if (self.verification.length == 0)
    {
        hudShowInfo(@"请先获取验证码");
    }
    else
    {
        if ([self.verification isEqualToString:captchaField.text])
        {
            TBSetPasswordViewController *setVC = [[TBSetPasswordViewController alloc] init];
            setVC.isModify = self.viewControllerType;
            [self.navigationController pushViewController:setVC animated:YES];
        }
        else
        {
            hudShowError(@"验证码输入错误");
        }
    }
}


#pragma mark  -- uitextFieldDelegate ---

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self.view endEditing:YES];
    return YES;
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
