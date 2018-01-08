//
//  TBPublishingGroupViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/13.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBPublishingGroupViewController.h"
#import "TBReleasePreviewViewController.h"
#import "TBGroupPhotoChooseView.h"//照片
#import "TBGroupSpecificationView.h"//说明
#import "TBPublishingGroupViewMode.h"
#import "TBMoreReminderView.h"
#import "WSDatePickerView.h"
#import "IQTextView.h"
@interface TBPublishingGroupViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *originalField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet TBGroupPhotoChooseView *photoChooseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoChooseHeight;
@property (weak, nonatomic) IBOutlet TBGroupSpecificationView *SpecificationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SpecificationHeight;
@property (weak, nonatomic) IBOutlet UIButton *startButton;//开始时间
@property (weak, nonatomic) IBOutlet UIButton *endButton;//结束时间
@property (weak, nonatomic) IBOutlet UIButton *effectiveButton;//上线时间

@property (weak, nonatomic) IBOutlet UITextField *maxNumberField;
@property (weak, nonatomic) IBOutlet UITextField *selfMoneyField;
@property (weak, nonatomic) IBOutlet UIButton *numberOneButton;
@property (weak, nonatomic) IBOutlet UIButton *numberTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *rulesOneButton;
@property (weak, nonatomic) IBOutlet UIButton *rulesTwoButton;
@property (weak, nonatomic) IBOutlet UITextField *rulesTextField;
@property (weak, nonatomic) IBOutlet UIButton *appointmentOneButton;
@property (weak, nonatomic) IBOutlet UIButton *appointmentTwoButton;
@property (weak, nonatomic) IBOutlet IQTextView *rulesTextView;
@property (nonatomic, strong) TBPublishingGroupList *groupList;//数据模型
@end

@implementation TBPublishingGroupViewController

- (TBPublishingGroupList *)groupList
{
    if (_groupList == nil)
    {
        _groupList = [[TBPublishingGroupList alloc] init];
    }
    return _groupList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"发布团购秒杀";
    [self configurationData];
}
#pragma mark --界面赋值---
- (void)configurationData
{
    NSDate *date = [NSDate new];
    NSString *startTimeString = [self timeDate:date];
    NSString *endTimeString = [self getPriousorLaterDateFromDate:date withMonth:1];
    [self.startButton setTitle:startTimeString forState:UIControlStateNormal];
    [self.endButton setTitle:endTimeString forState:UIControlStateNormal];
    [self.effectiveButton setTitle:[date stringWithFormat:@"yyyy-MM-dd HH:mm"] forState:UIControlStateNormal];
    
    self.footView.layer.masksToBounds = YES;
    self.footView.layer.cornerRadius = 22;
    self.footView.clipsToBounds = YES;
    
    self.nameField.delegate = self;
    self.originalField.delegate = self;
    self.priceField.delegate = self;
    self.numberField.delegate = self;
    self.phoneField.delegate = self;
    self.maxNumberField.delegate = self;
    self.selfMoneyField.delegate = self;
    self.rulesTextView.delegate = self;
    self.rulesTextField.delegate = self;
    
    [self.photoChooseView updataCollectionView];
    self.SpecificationView.maxNumber = 12;
    TBWeakSelf
    //照片选择事件
    [self.photoChooseView setUpdataPhotoViewHeight:^(CGFloat height){
        
        weakSelf.photoChooseHeight.constant = height;
    }];
    // 产品介绍高度更新
    [self.SpecificationView updataViewHeight:^(CGFloat viewHeight) {
        
        weakSelf.SpecificationHeight.constant = viewHeight;
    }];
    if (self.groupId.integerValue>0)
    {
        //请求编辑数据
        TBPublishingGroupViewMode *viewMode = [[TBPublishingGroupViewMode alloc] init];
        [viewMode postPublishingGroupData:self.groupId groupData:^(TBPublishingGroupList *list) {
            weakSelf.groupList = list;
            [weakSelf updataLabelText];
        }];
    }
   [self addInfoCellNumber:1];
}
//更新界面数据
- (void)updataLabelText
{
    self.nameField.text = self.groupList.name;
    self.originalField.text = self.groupList.price;
    self.priceField.text = self.groupList.sellprice;
    self.numberField.text = self.groupList.num;
    self.phoneField.text = self.groupList.ginfo;
    
    [self.photoChooseView.imageArray addObjectsFromArray:self.groupList.imgs];
    [self.photoChooseView updataCollectionView];
    [self.SpecificationView updataInfoArray:self.groupList.info];
    
    [self.startButton setTitle:self.groupList.sdate forState:UIControlStateNormal];
    [self.endButton setTitle:self.groupList.edate forState:UIControlStateNormal];
    [self.effectiveButton setTitle:self.groupList.time forState:UIControlStateNormal];
    
    if (self.groupList.limitnum.integerValue == 0)
    {
        [self numberButtonShow:YES];
    }
    else
    {
        self.maxNumberField.text = self.groupList.limitnum;
        [self numberButtonShow:NO];
    }
    
    if (self.groupList.refund.integerValue == 0)
    {
        [self rulesButtonShow:YES];
    }
    else
    {
        self.rulesTextField.text = self.groupList.refund;
        [self rulesButtonShow:NO];
    }
    
    if (self.groupList.bookdate.integerValue == 0)
    {
        [self appointmentButtonShow:YES];
    }
    else
    {
        self.selfMoneyField.text = self.groupList.bookdate;
        [self appointmentButtonShow:NO];
    }
    self.rulesTextView.text = self.groupList.buyknow;
}
#pragma mark -- 点击事件 ---
//介绍添加功能
- (void)addInfoCellNumber:(NSInteger)row
{
    [self.SpecificationView addInfoCellNumber:row];
}
//添加介绍
- (IBAction)addSpecification:(UIButton *)sender
{
    [self addInfoCellNumber:1];
}
//开始时间
- (IBAction)startClick:(UIButton *)sender
{
    [self showTimeSelectButton:sender];
}
//结束时间
- (IBAction)endClick:(UIButton *)sender
{
    [self showTimeSelectButton:sender];
}
//上线时间
- (IBAction)effectiveClick:(UIButton *)sender
{
    [self showTimeSelectButton:sender];
}
//按钮选中状态
- (IBAction)selectButtonState:(UIButton *)sender
{
    NSInteger state = sender.tag;
    
    switch (state) {
        case 100:
        [self numberButtonShow:YES];
        break;
        case 101:
        [self numberButtonShow:NO];
        break;
        case 102:
        [self rulesButtonShow:YES];
        break;
        case 103:
        [self rulesButtonShow:NO];
        break;
        case 104:
        [self appointmentButtonShow:YES];
        break;
        case 105:
        [self appointmentButtonShow:NO];
        break;
        default:
        break;
    }
}

//发布预览
- (IBAction)previewClick:(UIButton *)sender
{
    if (![self validationString:self.nameField.text msg:@"请填写产品名称"]) {return;}
    if (![self validationString:self.originalField.text msg:@"请填写产品原价"]) {return;}
    if (![self validationString:self.priceField.text msg:@"请填写团购价格"]) {return;}
    if (![self validationString:self.numberField.text msg:@"请填秒杀套数"]) {return;}
    if (![self validationString:self.phoneField.text msg:@"请填写预约电话"]) {return;}

    if (self.photoChooseView.imageArray.count == 0) {
        hudShowError(@"请至少选择一张图片");
        return;
    }
    NSArray *infoArray = [self.SpecificationView accessToIntroduceData];
    if (infoArray.count == 0)
    {
        hudShowError(@"请至少写一条产品介绍");
        return;
    }
    NSString *startString = self.startButton.titleLabel.text;
    NSString *endString = self.endButton.titleLabel.text;
    NSInteger startFloat = [startString stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
    NSInteger endFloat = [endString stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
    
    if (startString.length == 0 || endString.length == 0)
    {
        hudShowError(@"请选择有效期");
        return;
    }
    if (startFloat>endFloat)
    {
        hudShowError(@"请重新选择结束时间");
        return;
    }

    NSString *effectiveString = self.effectiveButton.titleLabel.text;
    NSString *efTimer = [effectiveString componentsSeparatedByString:@" "].firstObject;
    NSInteger effectiveFloat = [efTimer stringByReplacingOccurrencesOfString:@"-" withString:@""].integerValue;
    if (effectiveString.length == 0)
    {
        hudShowError(@"请选择上线时间");
        return;
    }
    if (effectiveFloat<startFloat||effectiveFloat>endFloat)
    {
        hudShowError(@"上线时间有误");
        return;
    }
    NSString *limitnumber = @"";//限购数量
    if (self.numberOneButton.selected == YES)
    {
        limitnumber = @"0";
    }
    else if (self.maxNumberField.text.length>0)
    {
        limitnumber = self.maxNumberField.text;
    }
    else
    {
        hudShowError(@"请填写每人最多购买数量");
        return;
    }
    NSString *refundate = @"";//退款规则
    if (self.rulesOneButton.selected == YES) {
        refundate = @"0";
    }
    else if (self.rulesTextField.text.length>0)
    {
        refundate = self.rulesTextField.text;
    }
    else
    {
        hudShowError(@"请填写过期后几天可以退款");
        return;
    }
    NSString *limitdate = @"";//预约方式
    if (self.appointmentOneButton.selected == YES) {
        limitdate = @"0";
    }
    else if (self.selfMoneyField.text.length>0)
    {
        limitdate = self.selfMoneyField.text;
    }
    else
    {
        hudShowError(@"请填写预约金额");
        return;
    }
    NSString *buyknow = self.rulesTextView.text;
 
    self.groupList.name = self.nameField.text;
    self.groupList.price = self.originalField.text;
    self.groupList.sellprice = self.priceField.text;
    self.groupList.num = self.numberField.text;
    self.groupList.ginfo = self.phoneField.text;
    self.groupList.imgs = self.photoChooseView.imageArray;
    self.groupList.sdate = startString;
    self.groupList.edate = endString;
    self.groupList.time = effectiveString;
    self.groupList.info = infoArray;
    self.groupList.limitnum = limitnumber;
    self.groupList.bookdate = limitdate;
    self.groupList.refund = refundate;
    self.groupList.buyknow = buyknow;
    self.groupList.ID = self.groupId;
    self.groupList.shopid = self.shopId;
    self.groupList.shopname = self.shopname;
    TBReleasePreviewViewController *preView = [[TBReleasePreviewViewController alloc] init];
    preView.groupList = self.groupList;
    [self.navigationController pushViewController:preView animated:YES];
}

//取消
- (IBAction)cancelClick:(UIButton *)sender
{
    TBWeakSelf
    TBMoreReminderView *reminderView = [[TBMoreReminderView alloc] initShowPrompt:@"是否取消发布团购秒杀?"];
    [reminderView showHandler:^{
        
        [weakSelf backViewController];
    }];
}
#pragma mark --代理区域---
#pragma mark --- UITextFieldDelegate ---
// 禁止文本其它操作
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if ([textField isEqual:self.maxNumberField])
    {
        [self numberButtonShow:self.maxNumberField.text.length == 0];
        return;
    }
    if ([textField isEqual:self.selfMoneyField]) {
        [self appointmentButtonShow:self.selfMoneyField.text.length == 0];
        return;
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.phoneField]&&textField.text.length>0)
    {
        if ([ZKUtil checkNumber:textField.text] == NO)
        {
            hudShowError(@"请输入正确的电话");
            self.phoneField.text = @"";
        }
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![textField isEqual:self.nameField]) {
        
        if (textField.text.length == 1&&string.length>0)
        {
            if (textField.text.integerValue == 0&&![string isEqualToString:@"."])
            {
                hudShowError(@"输入格式错误");
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
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > 12) {
        
        textField.text = [toBeString substringToIndex:12];
        hudShowError(@"字数不能超过12个");
        return NO;
    }
    
    return YES;
}
#pragma mark --UITextView--
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *toBeString = textView.text;
    NSString *lang = textView.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"])
    {
        UITextRange *selectedRange = [textView markedTextRange];
        if (!selectedRange && toBeString.length>40)
        {
            hudShowError(@"不能超过40个字");
            textView.text = [toBeString substringToIndex:40];
        }
    }
    else if (toBeString.length > 40)
    {
        hudShowError(@"不能超过40个字");
        textView.text = [toBeString substringToIndex:40];
    }
}

#pragma mark-- 逻辑区域---
- (void)numberButtonShow:(BOOL)show
{
    self.numberOneButton.selected = show;
    self.numberTwoButton.selected = !show;
}
- (void)rulesButtonShow:(BOOL)show
{
    self.rulesOneButton.selected = show;
    self.rulesTwoButton.selected = !show;
}
- (void)appointmentButtonShow:(BOOL)show
{
    self.appointmentOneButton.selected = show;
    self.appointmentTwoButton.selected = !show;
}
//主线程返回
- (void)backViewController;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
- (void)showTimeSelectButton:(UIButton *)sender;
{
    NSString *format = @"";
    NSString *titel = sender.titleLabel.text;
    WSDateStyle style;
    NSDate *date;
    NSDate *eDate;
    NSString *startTime = self.startButton.titleLabel.text;
    NSString *endTime = self.endButton.titleLabel.text;
    
    if (sender.tag == 2002)
    {
        format = @"yyyy-MM-dd HH:mm";
        style = DateStyleShowYearMonthDayHourMinute;
        date = [self obtainMinLimitDate:startTime format:@"yyyy-MM-dd"];
        eDate = [self obtainMinLimitDate:endTime format:@"yyyy-MM-dd"];
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
        pickerView.maxLimitDate = eDate;
        pickerView.minLimitDate = date;
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
/**
 验证字符
 
 @param string 字符串
 @param msg 提示信息
 @return bool
 */
- (BOOL)validationString:(NSString *)string msg:(NSString *)msg
{
    if (string.length == 0)
    {
        hudShowError(msg);
        
        return NO;
    }
    return YES;
}

#pragma mark --时间操作---
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
