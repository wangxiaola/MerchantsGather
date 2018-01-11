//
//  TBDiscountCardView.m
//  Telecom
//
//  Created by 王小腊 on 2017/6/22.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBDiscountCardView.h"
#import "TBPreferentialListView.h"
#import "TBPreferentialStatusView.h"
@interface TBDiscountCardView()<TBPreferentialListViewDelegate>

@property (nonatomic, strong) TBPreferentialListView *amountView;
@property (nonatomic, strong) TBPreferentialListView *numberView;
@property (nonatomic, strong) TBPreferentialListView *rulesView;
@property (nonatomic, strong) TBPreferentialListView *limitView;
@property (nonatomic, strong) TBPreferentialStatusView *statusView;
@property (nonatomic, strong) NSMutableDictionary *parameter;

@end
@implementation TBDiscountCardView
{
    UIScrollView *scrollView;
}
- (NSMutableDictionary *)parameter
{
    if (!_parameter)
    {
        _parameter = [NSMutableDictionary dictionary];
        _parameter[@"money"] = @"9.5";//选择金额
        _parameter[@"selfmoney"] = @"0";//自定义金额
        _parameter[@"num"] = @"99999";//发放数量
        _parameter[@"ucondit"] = @"0";//使用规则
        _parameter[@"sdate"] = @"";//开始时间
        _parameter[@"edate"] = @"";//结束时间
        _parameter[@"id"] = @"";//卡券id
        _parameter[@"stype"] = @"ka";//优惠类型
        
    }
    return _parameter;
}
- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
        scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contenView addSubview:scrollView];
        [self setUpViews];
    }
    return self;
}
#pragma mark -- 布局 ---
- (void)setUpViews
{
    UIView *promptBackView = [[UIView alloc] init];
    promptBackView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:promptBackView];
    
    UIButton *promptTagView = [UIButton buttonWithType:UIButtonTypeCustom];
    [promptTagView setTitle:@" 提示" forState:UIControlStateNormal];
    [promptTagView setImage:[UIImage imageNamed:@"task_bt"] forState:UIControlStateNormal];
    [promptTagView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    promptTagView.titleLabel.font = [UIFont systemFontOfSize:15];
    [promptBackView addSubview:promptTagView];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"  为了让更多的网友分享您的店铺，你可以送出一些打折卡，给分享了您店铺的人，这样就会有更多的网友积极主动的帮您分享传播哦！";
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textColor = [UIColor blackColor];
    promptLabel.numberOfLines = 0;
    [promptBackView addSubview:promptLabel];
    [ZKUtil changeLineSpaceForLabel:promptLabel WithSpace:5.0];
    
    self.amountView = [[TBPreferentialListView alloc] initPreferentialType:PreferentialListTypeAmount isCard:YES];
    self.amountView.delegate = self;
    [scrollView addSubview:self.amountView];
    
    self.rulesView = [[TBPreferentialListView alloc] initPreferentialType:PreferentialListTypeRules isCard:YES];
    self.rulesView.delegate = self;
    [scrollView addSubview:self.rulesView];
    
    self.numberView = [[TBPreferentialListView alloc] initPreferentialType:PreferentialListTypeNumber isCard:YES];
    self.numberView.delegate = self;
    [scrollView addSubview:self.numberView];
    
    self.limitView = [[TBPreferentialListView alloc] initPreferentialType:PreferentialListTypeLimit isCard:YES];
    self.limitView.delegate = self;
    [scrollView addSubview:self.limitView];
    
    NSDate *date = [NSDate new];
    NSString *startTimeString = [self timeDate:date];
    NSString *endTimeString = [self getPriousorLaterDateFromDate:date withMonth:6];
    [self.limitView updataStartTime:startTimeString endTime:endTimeString];
    
    self.parameter[@"sdate"] = startTimeString;
    self.parameter[@"edate"] = endTimeString;
    
    self.statusView = [[TBPreferentialStatusView alloc] initPromptString:@"是否发布打折卡"];
    [scrollView addSubview:self.statusView];
    TBWeakSelf
    [self.statusView setPreferentialStatus:^(BOOL state){
        [weakSelf setPreferentialDataStatus:state];
    }];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contenView);
    }];
    [promptBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollView);
        make.top.equalTo(scrollView.mas_top).offset(10);
    }];
    [promptTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(promptBackView).offset(10);
        make.height.equalTo(@16);
    }];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView.mas_left).offset(10);
        make.right.equalTo(scrollView.mas_right).offset(-10);
        make.width.mas_equalTo(_SCREEN_WIDTH-20);
        make.top.equalTo(promptTagView.mas_bottom).offset(6);
        make.bottom.equalTo(promptBackView.mas_bottom).offset(-8);
    }];
    
    [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(scrollView);
        make.top.equalTo(promptBackView.mas_bottom).offset(10);
    }];
    
    [self.rulesView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(scrollView);
        make.top.equalTo(weakSelf.amountView.mas_bottom).offset(10);
    }];
    
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(scrollView);
        make.top.equalTo(weakSelf.rulesView.mas_bottom).offset(10);
    }];
    
    [self.limitView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(scrollView);
        make.top.equalTo(weakSelf.numberView.mas_bottom).offset(10);
    }];
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(scrollView);
        make.height.equalTo(@50);
        make.top.equalTo(weakSelf.limitView.mas_bottom).offset(10);
        make.bottom.mas_lessThanOrEqualTo(scrollView.mas_bottom).offset(-40);
    }];

}
/**
 设置优惠信息
 
 @param state 状态
 */
- (void)setPreferentialDataStatus:(BOOL)state
{
    NSString *type = @"";
    NSString *number = @"";
    NSString *num = @"";
    
    if (state == YES)
    {
        type = @"money";
        number= @"9.5";
        num = @"99999";
        self.parameter[@"money"] = @"9.5";//选择金额
        self.parameter[@"selfmoney"] = @"0";//自定义金额
    }
    else
    {
        type = @"selfmoney";
        number= @"10";
        num = @"0";
        self.parameter[@"money"] = @"0";//选择金额
        self.parameter[@"selfmoney"] = @"10";//自定义金额
    }
    self.parameter[@"num"] = num;//发放数量
    NSDictionary *dic = @{@"number":number,@"type":type};
    [self.amountView updataViewList:dic PreferentialType:PreferentialListTypeAmount];
    [self.numberView updataViewList:num PreferentialType:PreferentialListTypeNumber];

}
#pragma mark ---TBPreferentialListViewDelegate---
//发放金额
- (void)theAmountSize:(NSDictionary *__nonnull)amount;
{
    NSString *type = [amount valueForKey:@"type"];
    NSString *number = [amount valueForKey:@"number"];
    if ([type isEqualToString:@"selfmoney"])
    {
        self.parameter[@"selfmoney"] = number.length == 0?@"9.5":number;
        self.parameter[@"money"] = @"0";
    }
    else
    {
        self.parameter[@"selfmoney"] = @"0";
        self.parameter[@"money"] = number;
    }
}
//发放数量
- (void)theNumberOf:(NSString *__nonnull)number;
{
    if (number.length>0)
    {
        NSLog(@" 发放数量 %@",number);
        self.parameter[@"num"] = number;
    }
}
//使用规则
- (void)usingRulesAmount:(NSString *__nonnull)rules;
{
    if (rules.length>0)
    {
        NSLog(@" 使用规则 %@",rules);
        self.parameter[@"ucondit"] = rules;
    }
}
//使用期限
- (void)usingPeriodOfTime:(NSString *__nonnull)time;
{
    self.parameter[@"edate"] = time;
    NSLog(@" 使用期限 %@",time);
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
#pragma mark -- 数据获取和提取 ---
/**
 数据更新
 
 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;
{
    self.makingList = makingList;
    
    if (makingList.discountCardDic.count>0)
    {
        
        NSString *money = [makingList.discountCardDic valueForKey:@"money"];
        NSString *selfmoney = [makingList.discountCardDic valueForKey:@"selfmoney"];
        NSString *num = [makingList.discountCardDic valueForKey:@"num"];
        NSString *ucondit = [makingList.discountCardDic valueForKey:@"ucondit"];
        NSString *sdate = [makingList.discountCardDic valueForKey:@"sdate"];
        NSString *edate = [makingList.discountCardDic valueForKey:@"edate"];
        NSString *ID = [makingList.discountCardDic valueForKey:@"id"];
        NSInteger maxNumber = 99999;
        
        NSString *number = selfmoney.doubleValue >= 0.0f && money.doubleValue == 0.0f ?selfmoney:money;
        NSString *type = selfmoney.doubleValue >= 0.0f && money.doubleValue == 0.0f ?@"selfmoney":@"money";
        NSDictionary *dic = @{@"number":number,@"type":type};
        
        if (money.doubleValue == 0.0f && selfmoney.doubleValue == 10.0f && num.integerValue == 0)
        {
            [self.statusView setSelectButtonState:NO];
        }
        
        [self.amountView updataViewList:dic PreferentialType:PreferentialListTypeAmount];
        self.parameter[@"money"] = money;//选择金额
        self.parameter[@"selfmoney"] = @"0";//自定义金额
        
        if (num.integerValue != maxNumber ) {
            
            [self.numberView updataViewList:num PreferentialType:PreferentialListTypeNumber];
            self.parameter[@"num"] = num;//发放数量
        }
        if (ucondit.integerValue != maxNumber && ucondit.integerValue>0)
        {
            [self.rulesView updataViewList:ucondit PreferentialType:PreferentialListTypeRules];
            self.parameter[@"ucondit"] = ucondit;//使用规则
        }
        self.parameter[@"sdate"] = sdate;//开始时间
        self.parameter[@"edate"] = edate;//结束时间
        [self.limitView updataStartTime:sdate endTime:edate];
        
        if (ID.integerValue>0)
        {
            self.parameter[@"id"] = ID;
        }
    }
     return @{@"name":@"打折卡优惠",@"prompt":@""};
}
/**
 数据提交
 
 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;
{
    self.makingList.discountCardDic = self.parameter;
    return YES;
}
@end
