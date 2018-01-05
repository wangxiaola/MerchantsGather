//
//  TBRegisteredViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBRegisteredViewController.h"
#import "TBRegisteredRegionView.h"
#import "TBCountdownSingle.h"
@interface TBRegisteredViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) NSArray *areaArray;
@property (weak, nonatomic) IBOutlet UIImageView *leftAreaImageView;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *validationTextField;
@property (weak, nonatomic) IBOutlet UIButton *validationButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registeredButton;
@property (nonatomic, strong) TBRegisteredRegionView *resultsView;
@property (nonatomic, strong) TBRegisteredRegionMode *mode;
@property (nonatomic, strong) NSString *verification;//验证码
@end

@implementation TBRegisteredViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"注册";
    [self setUpView];
    [self postAreaData];
}
#pragma mark --- 设置视图---
- (void)setUpView
{
    self.validationButton.layer.cornerRadius = 5;
    self.registeredButton.layer.cornerRadius = 6;
    self.phoneTextField.delegate = self;
    self.validationTextField.delegate = self;
    self.nameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    
    TBWeakSelf
    self.resultsView = [[TBRegisteredRegionView alloc] init];
    [self.view addSubview:self.resultsView];
    
    [self.resultsView setAdderssPoi:^(TBRegisteredRegionMode *poi) {
        [weakSelf showQueryResults:poi];
    }];
    
    [self.resultsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.areaTextField);
        make.top.equalTo(weakSelf.areaTextField.mas_bottom).offset(2);
        make.height.equalTo(@0);
    }];
    
}
#pragma mark -- 请求数据---
- (void)postAreaData
{
    NSMutableDictionary *dic = [NSMutableDictionary params];
    [dic setObject:@"245" forKey:@"interfaceId"];
    hudShowLoading(@"正在获取地区数据");
    [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        
        if ([errcode isEqualToString:@"00000"])
        {
            NSArray *root = [[responseObj valueForKey:@"data"] valueForKey:@"root"];
            self.areaArray = [TBRegisteredRegionMode mj_objectArrayWithKeyValuesArray:root];
            hudDismiss();
            
        }
        else
        {
            hudShowError(@"地区数据异常");
        }
    } failure:^(NSError *error) {
        hudShowError(@"网络异常");
    }];
    
}

/**
 验证唯一性
 */
- (void)verifyTheUniqueness
{
    hudShowLoading(@"手机号验证中");
    NSMutableDictionary *dic = [NSMutableDictionary params];
    [dic setValue:self.phoneTextField.text forKey:@"phone"];
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
    hudShowLoading(@"正在获取验证码");
    NSMutableDictionary *dic = [NSMutableDictionary params];
    [dic setValue:self.phoneTextField.text forKey:@"phone"];
    [dic setValue:@"2" forKey:@"shopid"];
    [dic setValue:@"171" forKey:@"interfaceId"];
    
    [dic setObject:@"zhuce" forKey:@"type"];
    
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
             [weakSelf.validationTextField becomeFirstResponder];//自动弹出键盘
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
- (void)requestIsSet
{
    hudShowLoading(@"正在申请");
    NSMutableDictionary *dic = [NSMutableDictionary params];
    [dic setObject:@"229" forKey:@"interfaceId"];
    [dic setObject:self.nameTextField.text forKey:@"name"];
    [dic setObject:self.phoneTextField.text forKey:@"phone"];
    [dic setObject:self.validationTextField.text forKey:@"code"];
    [dic setObject:@"1" forKey:@"ispwd"];
    [dic setObject:self.passwordTextField.text forKey:@"pwd"];
    [dic setObject:self.mode.ID forKey:@"pid"];
    
    [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
        
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        if ([errcode isEqualToString:@"00000"])
        {
            hudShowSuccess(@"注册成功");
            [ZKUtil saveBoolForKey:VALIDATION valueBool:NO];
            [self goBack];
        }
        else
        {
            hudShowError([responseObj valueForKey:@"errmsg"]);
        }
    } failure:^(NSError *error) {
        hudShowFailure();
        
    }];
    
}

#pragma mark  ---点击事件---
//选择地区
- (IBAction)areaSelectionClick:(UIButton *)sender
{
    if (self.areaArray.count>0)
    {
        [self.resultsView showAdderssPois:self.areaArray];
        [UIView animateWithDuration:0.4 animations:^{
            
            [self.resultsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@200);
            }];
            
        }];
        self.leftAreaImageView.image = [UIImage imageNamed:@"task-top"];
        
    }
    else
    {
        [UIView addMJNotifierWithText:@"地区数据还未加载" dismissAutomatically:YES];
        [self postAreaData];
    }
    
}
//验证码
- (IBAction)validationClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (self.phoneTextField.text.length == 0)
    {
        [UIView addMJNotifierWithText:@"请先输入手机号码" dismissAutomatically:YES];
        return;
    }
    if ([ZKUtil isMobileNumber:self.phoneTextField.text] == NO)
    {
        [UIView addMJNotifierWithText:@"请输入正确的手机号码" dismissAutomatically:YES];
        return;
    }
    [self verifyTheUniqueness];
}
//注册
- (IBAction)registeredClick:(UIButton *)sender
{
    [self dismissResults];
    [self.view endEditing:YES];
    if (self.areaTextField.text.length == 0)
    {
        [UIView addMJNotifierWithText:@"请选择地区" dismissAutomatically:YES];
        return;
    }
    if (self.phoneTextField.text.length == 0)
    {
        [UIView addMJNotifierWithText:@"请输入电话号码" dismissAutomatically:YES];
        return;
    }
    if ([ZKUtil isMobileNumber:self.phoneTextField.text] == NO)
    {
        [UIView addMJNotifierWithText:@"请输入正确的手机号码" dismissAutomatically:YES];
        return;
    }
    if (self.verification.length == 0)
    {
        [UIView addMJNotifierWithText:@"验证码还未获取到" dismissAutomatically:YES];
        return;
    }
    if (self.validationTextField.text.length == 0)
    {
        [UIView addMJNotifierWithText:@"请输入验证码" dismissAutomatically:YES];
        return;
    }
    if (self.nameTextField.text.length == 0)
    {
        [UIView addMJNotifierWithText:@"请输入昵称" dismissAutomatically:YES];
        return;
    }
    if (self.passwordTextField.text.length == 0)
    {
        [UIView addMJNotifierWithText:@"请输入密码" dismissAutomatically:YES];
        return;
    }
    if (self.confirmPasswordTextField .text.length == 0) {
        [UIView addMJNotifierWithText:@"请输入确认密码" dismissAutomatically:YES];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text])
    {
        [UIView addMJNotifierWithText:@"2次输入的密码不一致" dismissAutomatically:YES];
        return;
    }
    [self requestIsSet];
}
//协议
- (IBAction)goAgreementClick:(UIButton *)sender
{
    
}
//去登录
- (IBAction)loginClick:(UIButton *)sender
{
    [self goBack];
}
- (void)goBack
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
// 选中去的位置
- (void)showQueryResults:(TBRegisteredRegionMode *)poi
{
    self.mode = poi;
    self.areaTextField.text = poi.name;
    [self dismissResults];
}
- (void)dismissResults
{
     self.leftAreaImageView.image = [UIImage imageNamed:@"task-botton"];
    TBWeakSelf
    [UIView animateWithDuration:0.4 animations:^{
        [weakSelf.resultsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark ---UITextFieldDelegate--
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSString *toBeString = textField.text;
    
    if (toBeString.length +string.length >16)
    {
        [UIView addMJNotifierWithText:@"字数太多了" dismissAutomatically:YES];
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self dismissResults];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self dismissResults];
}
#pragma mark --计时--
// 开始计时
- (void)startTheDate:(int)number
{
    [[TBCountdownSingle sharedInstance] setUser:YES];
    TBWeakSelf
    [[TBCountdownSingle sharedInstance] startTheDatelength:number timeDate:^(NSString *numberString) {
        
        [weakSelf.validationButton setTitle:[NSString stringWithFormat:@"%@s",numberString] forState:UIControlStateNormal];
        weakSelf.validationButton.userInteractionEnabled = NO;
        
    } endTime:^{
        
        //设置界面的按钮显示 根据自己需求设置
        [weakSelf.validationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        weakSelf.validationButton.userInteractionEnabled = YES;
    }];
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
