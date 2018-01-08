//
//  TBReleaseCardVoucherViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBReleaseCardVoucherViewController.h"
#import "WSDatePickerView.h"
#import "TBMoreReminderView.h"
#import "TBDiscountsMode.h"

@interface TBReleaseCardVoucherViewController ()<UITextFieldDelegate>

@property (nonatomic) ReleaseType releaseType;
@property (nonatomic, strong) NSString *shopid;//商户ID
@property (weak, nonatomic) IBOutlet UIView *tagView;//标签视图
@property (weak, nonatomic) IBOutlet UITextField *customTextField;//自定义金额
@property (weak, nonatomic) IBOutlet UIButton *customButton;//自定义金额按钮
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;//单位
@property (weak, nonatomic) IBOutlet UITextField *issueTextField;//发放数量
@property (weak, nonatomic) IBOutlet UIButton *rulesOneButton;//订单金额点击
@property (weak, nonatomic) IBOutlet UITextField *rulesOneTextField;//订单金额
@property (weak, nonatomic) IBOutlet UIButton *rulesTwoButton;//自定义规则点击
@property (weak, nonatomic) IBOutlet UITextField *rulesTwoTextField;//自定义规则
@property (weak, nonatomic) IBOutlet UIButton *startButton;//开始时间
@property (weak, nonatomic) IBOutlet UIButton *endButton;//结束时间
@property (weak, nonatomic) IBOutlet UIButton *effectiveButton;//上线时间
@property (weak, nonatomic) IBOutlet UIView *bottomView;//底部视图
@property (strong, nonatomic) NSString *preferentialString;//优惠额度
@property (strong, nonatomic) NSArray *linesArray;//额度
@property (strong, nonatomic) NSMutableArray <UIButton *>*buttonArray;//额度
@property (nonatomic, strong) NSMutableDictionary *parameter;
@end

@implementation TBReleaseCardVoucherViewController
- (NSMutableDictionary *)parameter
{
    if (!_parameter)
    {
        _parameter = [NSMutableDictionary params];
    }
    return _parameter;
}
- (NSMutableArray<UIButton *> *)buttonArray
{
    if (!_buttonArray)
    {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
- (instancetype)initReleaseType:(ReleaseType)type shopid:(NSString *)shopid;
{
    self = [super init];
    if (self)
    {
        self.shopid = shopid;
        self.releaseType = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configurationData];
    if (self.list)
    {
        [self updataLabelText];
    }
}

#pragma mark --- 视图配置---
- (void)configurationData
{
    if (self.releaseType == ReleaseTypeVouchers)
    {
        [self.customButton setTitle:@"自定义金额" forState:UIControlStateNormal];
        self.unitLabel.text = @"元";
        self.linesArray = @[@"10元",@"20元",@"50元",@"100元",@"200元"];
    }
    else
    {
        [self.customButton setTitle:@"自定义折扣" forState:UIControlStateNormal];
        self.unitLabel.text = @"折";
        self.linesArray = @[@"5折",@"8折",@"8.5折",@"9折",@"9.5折"];
    }
    
    for (int i = 0; i<self.linesArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.linesArray[i] forState:UIControlStateNormal];
        button.layer.cornerRadius = 12;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = BODER_COLOR.CGColor;
        button.layer.borderWidth = 0.5;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(selectAmountButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.tagView addSubview:button];
        [self.buttonArray addObject:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagView.mas_left).offset((6+50)*i);
            make.height.equalTo(@24);
            make.width.equalTo(@50);
            make.centerY.equalTo(self.tagView.mas_centerY);
        }];
    }
    
    NSDate *date = [NSDate new];
    NSString *startTimeString = [self timeDate:date];
    NSString *endTimeString = [self getPriousorLaterDateFromDate:date withMonth:1];
    [self.startButton setTitle:startTimeString forState:UIControlStateNormal];
    [self.endButton setTitle:endTimeString forState:UIControlStateNormal];
    [self.effectiveButton setTitle:[date stringWithFormat:@"yyyy-MM-dd HH:mm"] forState:UIControlStateNormal];
    
    self.navigationItem.title = self.releaseType == ReleaseTypeVouchers?@"抵用券":@"打折卡";
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.layer.cornerRadius = 22;
    self.bottomView.clipsToBounds = YES;
    
    self.issueTextField.text = @"10";
    self.customTextField.delegate = self;
    self.issueTextField.delegate = self;
    self.rulesOneTextField.delegate = self;
    self.rulesTwoTextField.delegate = self;
    [self selectTagButton:self.releaseType == ReleaseTypeVouchers?2:3];
    
}
- (void)updataLabelText
{
    NSString *not = self.releaseType == ReleaseTypeVouchers?@"元":@"折";
    if (self.list.money1.integerValue >0)
    {
        self.customTextField.text = self.list.money1;
    }
    else
    {
        NSString *key = [NSString stringWithFormat:@"%@%@",self.list.money,not];
        [self.linesArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isEqualToString:key])
            {
                [self selectTagButton:idx];
            }
            
        }];
    }
    self.issueTextField.text = self.list.num;
    
    if (self.list.info.length >0)
    {
        [self rulesShowButton:self.rulesTwoButton];
        self.rulesTwoTextField.text = self.list.info;
    }
    else if (self.list.code.integerValue>0)
    {
        self.rulesOneTextField.text = self.list.con;
        [self rulesShowButton:self.rulesOneButton];
    }
    
    [self.startButton setTitle:self.list.sdate forState:UIControlStateNormal];
    [self.endButton setTitle:self.list.edate forState:UIControlStateNormal];
    [self.effectiveButton setTitle:self.list.online forState:UIControlStateNormal ];
    
}
#pragma mark ---发布卡券---
//数据验证
- (void)dataValidation
{
    if (self.preferentialString.length == 0 && self.customTextField.text.length == 0) {
        [self showMeg:@"请选择一个卡券额度"];
        return;
    }
    if (self.preferentialString.doubleValue == 0 && self.customTextField.text.doubleValue == 0) {
        [self showMeg:@"自定义数字不能为0！"];
        return;
    }
    if (self.issueTextField.text.length == 0)
    {
        [self showMeg:@"请填写发放数量"];
        return;
    }
    
    if (self.startButton.titleLabel.text.length == 0 || self.endButton.titleLabel.text.length == 0)
    {
        [self showMeg:@"请选择有效期限"];
        return;
    }
    if (self.effectiveButton.titleLabel.text.length == 0)
    {
        [self showMeg:@"请选择上线时间"];
        return;
    }
    if (self.rulesOneButton.selected == YES && self.rulesOneTextField.text.length == 0)
    {
        [self showMeg:@"没有填写满多少元可以使用"];
        return;
    }
    if (self.rulesTwoButton.selected == YES && self.rulesTwoTextField.text.length == 0)
    {
        [self showMeg:@"请填写自定义规则"];
        return;
    }
    
    NSString *startString = self.startButton.titleLabel.text;
    NSString *endString = self.endButton.titleLabel.text;
    NSInteger startFloat = [startString stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
    NSInteger endFloat = [endString stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;

    if (startFloat>endFloat)
    {
         [self showMeg:@"请重新选择结束时间"];
        return;
    }
    NSString *effectiveString = self.effectiveButton.titleLabel.text;
    NSString *efTimer = [effectiveString componentsSeparatedByString:@" "].firstObject;
    NSInteger effectiveFloat = [efTimer stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;

    if (effectiveFloat<startFloat||effectiveFloat>endFloat)
    {
        [self showMeg:@"上线时间有误"];
        return;
    }

    [self releaseCardVoucher];
}

// 发布卡券
- (void)releaseCardVoucher
{
    self.parameter[@"interfaceId"] = @"239";
    self.parameter[@"shopid"] = self.shopid;
    self.parameter[@"uid"] = [UserInfo account].userID;
    self.parameter[@"stype"] = self.releaseType == ReleaseTypeVouchers?@"hong":@"ka";
    self.parameter[@"num"] = self.issueTextField.text;
    if (self.rulesOneButton.selected == YES)
    {
        self.parameter[@"ucondit"] = self.rulesOneTextField.text;
    }
    else
    {
        self.parameter[@"ucondit"] = @"0";
    }
    if (self.rulesTwoButton.selected == YES)
    {
        self.parameter[@"info"] = self.rulesTwoTextField.text;
    }
    else
    {
        self.parameter[@"info"] = @"";
    }
    if (self.list)
    {
        self.parameter[@"id"] = self.list.ID;
    }
    if (self.preferentialString.length>0)
    {
        self.parameter[@"money"] = self.preferentialString;
    }
    else
    {
        self.parameter[@"money"] = @"0";
    }
    if (self.customTextField.text.length>0)
    {
        self.parameter[@"selfmoney"] = self.customTextField.text;
    }
    else
    {
        self.parameter[@"selfmoney"] = @"0";
    }
    self.parameter[@"sdate"] = self.startButton.titleLabel.text;
    self.parameter[@"edate"] = self.endButton.titleLabel.text;
    self.parameter[@"online"] = self.effectiveButton.titleLabel.text;

    [ZKPostHttp post:@"" params:self.parameter success:^(id responseObj) {
        
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        NSString *errmsg = [responseObj valueForKey:@"errmsg"];
        if ([errcode isEqualToString:@"00000"])
        {
            hudShowSuccess(errmsg);
            [self updataSuccess];
        }
        else
        {
            hudShowError(errmsg);
        }
        
    } failure:^(NSError *error) {
        hudShowError(@"网络异常");
    }];
}
- (void)updataSuccess
{
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:CardVoucherNotice object:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];

    [self backViewController];
}
//提示
- (void)showMeg:(NSString *)meg
{
    [UIView addMJNotifierWithText:meg dismissAutomatically:YES];
}
#pragma mark -- 点击事件 ---

- (IBAction)rulesOneClick:(UIButton *)sender
{
    [self rulesShowButton:self.rulesOneButton];
}
- (IBAction)rulesTwoClick:(UIButton *)sender
{
    [self rulesShowButton:self.rulesTwoButton];
}
- (IBAction)startClick:(UIButton *)sender
{
    [self showTimeSelectButton:sender];
}
- (IBAction)endClick:(UIButton *)sender
{
    [self showTimeSelectButton:sender];
}
- (IBAction)effectiveClick:(UIButton *)sender
{
    [self showTimeSelectButton:sender];
}
- (IBAction)releaseCardClick:(UIButton *)sender
{
    [self showPromptViewRelease:YES];
}
- (IBAction)cancelReleaseClick:(UIButton *)sender
{
   [self showPromptViewRelease:NO];
}
- (void)selectAmountButton:(UIButton *)send
{
    self.customTextField.text = @"";
    [self selectTagButton:send.tag-1000];
    
}
#pragma mark ---逻辑处理---
- (void)selectTagButton:(NSInteger)tag
{
    if (tag<self.linesArray.count)
    {
        NSString *key = self.linesArray[tag];
        NSString *not = self.releaseType == ReleaseTypeVouchers?@"元":@"折";
        self.preferentialString = [key stringByReplacingOccurrencesOfString:not withString:@""];
    }
    else
    {
        self.preferentialString = @"";
    }
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ((obj.tag-1000) == tag)
        {
            [obj setBackgroundColor:[UIColor orangeColor]];
            obj.layer.borderWidth = 0.0f;
            [obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            [obj setBackgroundColor:[UIColor whiteColor]];
            obj.layer.borderWidth = 0.5f;
            [obj setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }];
}
- (void)rulesShowButton:(UIButton *)sendr;
{
    if (sendr.selected == NO)
    {
        [sendr setImage:[UIImage imageNamed:@"task-choice-hover"] forState:UIControlStateNormal];
        sendr.selected = YES;
    }
    else
    {
        [sendr setImage:[UIImage imageNamed:@"task-choice"] forState:UIControlStateNormal];
        sendr.selected = NO;

    }
}
- (void)showTimeSelectButton:(UIButton *)sender;
{
    NSString *format = @"";
    NSString *titel = sender.titleLabel.text;
    WSDateStyle style;
    NSDate *date;
    NSString *startTime = self.startButton.titleLabel.text;
    NSString *endTime = self.endButton.titleLabel.text;
    
    if (sender.tag == 2002)
    {
        format = @"yyyy-MM-dd HH:mm";
        style = DateStyleShowYearMonthDayHourMinute;
        date = [self obtainMinLimitDate:endTime format:@"yyyy-MM-dd"];
    }
    else
    {
        format = @"yyyy-MM-dd";
        style = DateStyleShowYearMonthDay;
        if (sender.tag == 2000)//开始时间大于现在
        {
            date = [NSDate date];
        }
        else //结束时间大于开始时间
        {
            date = [self obtainMinLimitDate:startTime format:format];
        }
    }
    
    WSDatePickerView *pickerView = [[WSDatePickerView alloc] initWithDateStyle:style CompleteBlock:^(NSDate *startDate) {
        
        NSString *date = [startDate stringWithFormat:format];
        [sender setTitle:date forState:UIControlStateNormal];
        
    }];
    if (titel.length>0)
    {
        pickerView.scrollToDate = [NSDate date:titel WithFormat:format];
    }
    if (sender.tag == 2002)
    {
        pickerView.maxLimitDate = date;
        pickerView.minLimitDate = [NSDate date];
    }
    else
    {
        pickerView.minLimitDate = date;
    }
    pickerView.doneButtonColor = NAVIGATION_COLOR;//确定按钮的颜色
    [pickerView show];
}

/**
 获取时间

 @param date 时间字符串
 @param format 格式
 @return date
 */
- (NSDate *)obtainMinLimitDate:(NSString *)date format:(NSString *)format
{
    NSDate *minDate;
    if (date.length>0)
    {
        minDate = [NSDate date:date WithFormat:format];
    }
    else
    {
        minDate = [NSDate date];
    }
    return minDate;

}
- (void)showPromptViewRelease:(BOOL)type;
{
    NSString *typeSd = self.releaseType == ReleaseTypeVouchers ?@"现在就发布你的抵用券吗？":@"现在就发布你的打折卡吗？";
    NSString *meg = type == YES?typeSd:@"确认取消发布吗?";
    TBWeakSelf
    TBMoreReminderView *reminderView = [[TBMoreReminderView alloc] initShowPrompt:meg];
    [reminderView showHandler:^{
        
        if (type)
        {
            [weakSelf dataValidation];
        }
        else
        {
            [weakSelf backViewController];
        }
    }];
    
}
//主线程返回
- (void)backViewController;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
#pragma mark --- UITextFieldDelegate ---
// 禁止文本其它操作
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if (textField.text.length>0)
    {
        if (textField.tag == 100)
        {
            [self selectTagButton:1000];
        }
        else if (textField.tag == 102)
        {
            self.rulesOneButton.selected = NO;
            [self rulesShowButton:self.rulesOneButton];
        }
        else if (textField.tag == 103)
        {
             self.rulesTwoButton.selected = NO;
             [self rulesShowButton:self.rulesTwoButton];
        }
        
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""] || string.length == 0)
    { //按下return
        return YES;
    }
//      var reg = /(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)/;
    if ([textField isEqual:self.rulesTwoTextField])
    {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (toBeString.length > 25) {
            
            textField.text = [toBeString substringToIndex:25];
            hudShowError(@"字数不能超过25个");
            return NO;
        }
    }
    else
    {
        if (self.releaseType == ReleaseTypeDiscount&&[textField isEqual:self.customTextField]) {
            
            NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
            double pre = str.doubleValue;
            
            if (pre > 10 || pre < 0)
            {
                hudShowError(@"折扣格式不对");
                return NO;
            }
        }
        else if (textField.text.length == 0)
        {
            if ([string integerValue] == 0)
            {
                hudShowError(@"请输入非零整数");
                return NO;
            }
        }

        
        if (textField.text.length == 1)
        {
            if (textField.text.integerValue == 0&&string.integerValue == 0)
            {
                hudShowError(@"只能输入小数点或大于0的数字");
                return NO;
            }
        }
        NSCharacterSet *cs;
        
        NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
        if (NSNotFound == nDotLoc && 0 != range.location) {
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
        }
        else {
            cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
        }
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            
            hudShowError(@"只能输入数字");
            return NO;
        }
        if (NSNotFound != nDotLoc && range.location > nDotLoc + 2) {
            hudShowError(@"小数点后最多二位");
            return NO;
        }

    }
    
    return YES;
}
#pragma mark --date---
//获取几个月时间
-(NSString *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return [self timeDate:mDate];
    
}
- (NSString *)timeDate:(NSDate *)currentDate
{
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    
    return currentDateString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
