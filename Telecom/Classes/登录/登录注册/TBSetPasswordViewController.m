//
//  TBSetPasswordViewController.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/2.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBSetPasswordViewController.h"
#import "ZKTextField.h"
#import "ZKNavigationController.h"
#import "NSString+MD5Addition.h"

@interface TBSetPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) ZKTextField *passwordTextField;

@property (nonatomic, strong) ZKTextField *nicknameTextField;

@end

@implementation TBSetPasswordViewController
@synthesize passwordTextField,nicknameTextField;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(245, 246, 247);
    self.title = @"密码设置";
    
    [self initViews];
}
#pragma mark --- 构图----
- (void)initViews
{
    UIView *fieldView = [[UIView alloc] init];
    fieldView.backgroundColor = [UIColor whiteColor];
    fieldView.layer.masksToBounds = YES;
    fieldView.layer.cornerRadius = 3;
    fieldView.layer.borderWidth = 0.5;
    fieldView.layer.borderColor = BODER_COLOR.CGColor;
    [self.view addSubview:fieldView];
    
    UIView *nicknameView = [[UIView alloc] init];
    nicknameView.backgroundColor = [UIColor whiteColor];
    nicknameView.layer.masksToBounds = YES;
    nicknameView.layer.cornerRadius = 3;
    nicknameView.layer.borderWidth = 0.5;
    nicknameView.layer.borderColor = BODER_COLOR.CGColor;
    [self.view addSubview:nicknameView];
    
    if (self.isModify == NO)
    {
        nicknameTextField = [[ZKTextField alloc] init];
        nicknameTextField.placeholder = @"请输入您的昵称";
        nicknameTextField.delegate = self;
        nicknameTextField.textColor = [UIColor blackColor];
        nicknameTextField.font = [UIFont systemFontOfSize:14];
        [nicknameTextField setValue:[UIFont boldSystemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
        nicknameTextField.borderStyle = UITextBorderStyleNone;
        nicknameTextField.returnKeyType = UIReturnKeyDone;
        [nicknameView addSubview:nicknameTextField];
    }
    
    passwordTextField = [[ZKTextField alloc] init];
    passwordTextField.placeholder = @"请设置您的密码";
    passwordTextField.delegate = self;
    passwordTextField.textColor = [UIColor blackColor];
    passwordTextField.font = [UIFont systemFontOfSize:14];
    [passwordTextField setValue:[UIFont boldSystemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    passwordTextField.borderStyle = UITextBorderStyleNone;
    passwordTextField.keyboardType =  UIKeyboardTypeAlphabet;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    [fieldView addSubview:passwordTextField];
    
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = BODER_COLOR;
    [fieldView addSubview:linView];
    
    UIButton * showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [showButton setTitle:@"隐藏字符" forState:UIControlStateNormal];
    [showButton setTitleColor:RGB(24, 196, 157) forState:UIControlStateNormal];
    [showButton addTarget:self action:@selector(showFieldClick:) forControlEvents:UIControlEventTouchUpInside];
    showButton.selected = YES;
    [fieldView addSubview:showButton];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.backgroundColor = NAVIGATION_COLOR;
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 3;
    [sendButton setTitle:@"完 成" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:0.4];
    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    float nicknameHeight = self.isModify == NO?44:0.0f;
    /******* 布局 ********/
    [nicknameView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(18+64);
            make.height.mas_equalTo(nicknameHeight);
    }];
    
    [fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(nicknameView.mas_bottom).offset(18);
        make.height.mas_equalTo(44);
    }];
    
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(1);
        make.right.mas_equalTo(fieldView.mas_right).mas_equalTo(-76);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        
    }];
    
    
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(fieldView.mas_left).mas_equalTo(8);
        make.right.mas_equalTo(linView.mas_left).mas_equalTo(-4);
        make.top.bottom.mas_equalTo(0);
    }];
    
    if (self.isModify == NO)
    {
        [nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(nicknameView.mas_left).mas_equalTo(8);
            make.right.mas_equalTo(nicknameView.mas_right).mas_equalTo(-4);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    [showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(linView.mas_right).mas_equalTo(0);
        make.right.mas_equalTo(fieldView.mas_right).mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(fieldView.mas_bottom).offset(18);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark  --- 点击事件 ---
- (void)showFieldClick:(UIButton*)button
{
    [self.view endEditing:YES];
    NSString *type = button.selected?@"显示字符":@"隐藏字符";
    [button setTitle:type forState:UIControlStateNormal];
    passwordTextField.secureTextEntry = button.selected;
    button.selected  = !button.selected;
    
    
}
- (void)sendClick
{
    [self.view endEditing:YES];
    
    if (passwordTextField.text.length == 0)
    {
        hudShowError(@"请填写新密码");
        return;
    }
    if (self.isModify == NO)
    {
        if (self.nicknameTextField.text.length == 0)
        {
            hudShowError(@"请输入您的昵称");
            return;
        }
    }
    
    [self requestIsSet];
}
- (void)requestIsSet
{
    NSString *code = [ZKUtil getUserDataForKey:Verification_code];
    NSString*phone = [ZKUtil getUserDataForKey:Verification_phone];
    
    if (code.length == 0)
    {
        hudShowInfo(@"验证码已失效!");
        return;
    }
    
    hudShowLoading(@"正在申请");
    
    NSMutableDictionary *dic = [NSMutableDictionary params];
    [dic setObject:phone forKey:@"phone"];
    [dic setObject:[passwordTextField.text stringFromMD5] forKey:@"pwd"];
    [dic setObject:code forKey:@"code"];
    
    if (self.isModify == YES)
    {
        [dic setObject:@"185" forKey:@"interfaceId"];
    }
    else
    {
        [dic setObject:@"229" forKey:@"interfaceId"];
        [dic setObject:nicknameTextField.text forKey:@"name"];
    }

    [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
        
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        if ([errcode isEqualToString:@"00000"])
        {
            hudShowSuccess([responseObj valueForKey:@"errmsg"]);
            
            [ZKUtil saveBoolForKey:VALIDATION valueBool:NO];
            UserInfo *info = [[UserInfo alloc] init];
            info.phone = phone;
            [UserInfo saveAccount:info];
            
            ZKNavigationController *nav = [[ZKNavigationController alloc] initWithRootViewController:[NSClassFromString(@"TBLogInViewController") new]];
            [APPDELEGATE window].rootViewController = nav;
        }
        else
        {
            hudShowError([responseObj valueForKey:@"errmsg"]);
        }
    } failure:^(NSError *error) {
        hudShowFailure();
        
    }];

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
