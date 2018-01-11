//
//  TBPreferentialListView.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/8.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBPreferentialListView.h"
#import "WSDatePickerView.h"

static NSString *const imageHighlighted = @"task-choice-hover";
static NSString *const imageNormal = @"task-choice";

@interface TBPreferentialListView ()<UITextFieldDelegate>

@end
@implementation TBPreferentialListView
{
    PreferentialListType _viewType;
    UIView               *_bottomView;
    NSArray              *_viewArray;
    UITextField          *_textField;
    NSArray              *_priceArray;
    UIScrollView         *_scrollView;
    BOOL                 _isCard;
    struct {
        unsigned int     typeAmount :1;
        unsigned int     typeNumber :1;
        unsigned int     typeRules  :1;
        unsigned int     typeLimit  :1;
        
    }_delegateFlags;
}
/**
 创建小控件
 
 @param type 类型
 @param card 是否打折卡
 @return view
 */
- (instancetype __nonnull )initPreferentialType:(PreferentialListType)type isCard:(BOOL)card;
{
    self = [super init];
    if (self)
    {
        _isCard = card;
        _viewType = type;
        [self setUpView];
    }
    
    return self;
}
- (void)setDelegate:(id<TBPreferentialListViewDelegate>)delegate
{
    _delegate = delegate;
    _delegateFlags.typeAmount = [delegate respondsToSelector:@selector(theAmountSize:)];
    _delegateFlags.typeNumber = [delegate respondsToSelector:@selector(theNumberOf:)];
    _delegateFlags.typeRules = [delegate respondsToSelector:@selector(usingRulesAmount:)];
    _delegateFlags.typeLimit = [delegate respondsToSelector:@selector(usingPeriodOfTime:)];
}
#pragma mark --- setUpView ---
- (void)setUpView
{
    self.backgroundColor = [UIColor whiteColor];
    //上面部分
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:nameLabel];
    
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = BODER_COLOR;
    [self addSubview:linView];
    
    _bottomView = [[UIView alloc] init];
    [self addSubview:_bottomView];
    //下面部分
    if (_viewType == PreferentialListTypeAmount)
    {
        nameLabel.text = _isCard == YES?@"发放折扣":@"发放金额";
        _priceArray = _isCard ?@[@"9.5折",@"9.0折",@"8.5折",@"8.0折"]:@[@"5元",@"10元",@"20元",@"50元"];
        [self addSelectButtonView];
        [self addNumberTextFieldImageType:NO];
    }
    else if (_viewType == PreferentialListTypeNumber)
    {
        nameLabel.text = @"发放数量";
        [self addNumberTextFieldImageType:YES];
    }
    else if (_viewType == PreferentialListTypeRules)
    {
        nameLabel.text = @"使用规则";
        [self addNumberTextFieldImageType:YES];
    }
    else if (_viewType == PreferentialListTypeLimit)
    {
        nameLabel.text = @"使用期限";
        [self addTimeView];
    }
    TBWeakSelf
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.height.equalTo(@40);
        
    }];
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(weakSelf);
        make.top.equalTo(linView.mas_bottom);
        make.height.equalTo(@50);
    }];
}
#pragma mark --- 赋值 ---
- (void)updataViewList:(id  __nonnull )data PreferentialType:(PreferentialListType)type;
{
    if (data)
    {
        if (_viewType == PreferentialListTypeAmount)
        {
            NSString *type = [data valueForKey:@"type"];
            NSString *number = [data valueForKey:@"number"];
            if ([type isEqualToString:@"money"])
            {
                _textField.text = @"";
                [self selectTagButton:9999 keyName:number];
            }
            else
            {
                _textField.text = number;
                [self selectTagButton:9999 keyName:@"9999"];
            }
            
            
            return;
        }
        if (_viewType == PreferentialListTypeRules)
        {
            _textField.text = data;
            [self selectNumberButtonState:1010];
            return;
        }
        if (_viewType == PreferentialListTypeNumber)
        {
            NSString *num = data;
            if (num.integerValue == 99999) {
                _textField.text = @"";
                [self selectNumberButtonState:1011];
            }
            else
            {
                _textField.text = data;
                [self selectNumberButtonState:1010];
            }
            
            return;
        }
    }
}
- (void)updataStartTime:(NSString *__nonnull)startTime endTime:(NSString *__nonnull)endTime;
{
    if (_viewType == PreferentialListTypeLimit && _viewArray.count == 2)
    {
        UIButton *startButton = _viewArray.firstObject;
        UIButton *endButton = _viewArray.lastObject;
        
        [startButton setTitle:startTime forState:UIControlStateNormal];
        [endButton setTitle:endTime forState:UIControlStateNormal];
    }
}
#pragma mark --- toolView ---
- (void)addNumberTextFieldImageType:(BOOL)type
{
    NSString *oneString = @"";
    NSString *twoString = @"";
    NSString *unitString = @"";
    if (_viewType == PreferentialListTypeAmount)
    {
        oneString = _isCard?@"自定义折扣":@"自定义金额";
        unitString = _isCard?@"折":@"元";
    }
    else if (_viewType == PreferentialListTypeNumber)
    {
        oneString = @" 发放数量";
        twoString = @" 数量不限";
        unitString = @"份";
    }
    else if (_viewType == PreferentialListTypeRules)
    {
        oneString = @" 消费金额满";
        twoString = @" 使用不限";
        unitString = @"元使用";
    }
    
    UIButton *oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [oneButton setTitle:oneString forState:UIControlStateNormal];
    [oneButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    oneButton.titleLabel.font = [UIFont systemFontOfSize:14];
    oneButton.tag = 1010;
    [_bottomView addSubview:oneButton];
    
    _textField = [[UITextField alloc] init];
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.textColor = [UIColor blackColor];
    _textField.textAlignment = NSTextAlignmentCenter;
    if (_viewType == PreferentialListTypeNumber)
    {
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else
    {
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor clearColor];
    _textField.borderStyle = UITextBorderStyleNone;
    [_bottomView addSubview:_textField];
    
    UIView *verView = [[UIView alloc] init];
    verView.backgroundColor = BODER_COLOR;
    [_bottomView addSubview:verView];
    
    UILabel *unitLabel = [[UILabel alloc] init];
    unitLabel.textColor = [UIColor grayColor];
    unitLabel.text = unitString;
    unitLabel.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:unitLabel];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneButton.mas_right).offset(2);
        make.right.equalTo(unitLabel.mas_left).offset(-2);
        make.width.mas_greaterThanOrEqualTo(40);
        make.width.mas_lessThanOrEqualTo(80);
        make.height.equalTo(oneButton.mas_height);
        make.centerY.equalTo(_bottomView.mas_centerY);
    }];
    
    [verView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_textField);
        make.top.equalTo(_textField.mas_bottom).offset(1);
        make.height.equalTo(@1.0f);
    }];
    if (type == YES)
    {
        [oneButton addTarget:self action:@selector(oneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [oneButton setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
        
        UIButton *twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [twoButton setTitle:twoString forState:UIControlStateNormal];
        [twoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        twoButton.tag = 1011;
        twoButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [twoButton setImage:[UIImage imageNamed:imageHighlighted] forState:UIControlStateNormal];
        [twoButton addTarget:self action:@selector(twoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:twoButton];
        
        [oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_bottomView.mas_centerY);
        }];
        
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_bottomView.mas_centerY);
            make.right.equalTo(_bottomView.mas_right).offset(-10);
        }];
        
        [twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomView.mas_left).offset(10);
            make.centerY.equalTo(_bottomView.mas_centerY);
        }];
        
        _viewArray = [NSArray arrayWithObjects:oneButton,twoButton, nil];
        
    }
    else
    {
        [oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_scrollView.mas_right).offset(10);
            make.centerY.equalTo(_bottomView.mas_centerY);
            
        }];
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_bottomView.mas_centerY);
            make.right.equalTo(_bottomView.mas_right).offset(-10);
        }];
    }
}
// 多选按钮
- (void )addSelectButtonView
{
    
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:_priceArray.count];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    [_bottomView addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView.mas_left).offset(10);
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.height.equalTo(@26);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    for (int i = 0; i<_priceArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_priceArray[i] forState:UIControlStateNormal];
        button.layer.cornerRadius = 12;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = BODER_COLOR.CGColor;
        button.layer.borderWidth = 0.5;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(selectAmountButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        [buttonArray addObject:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_scrollView.mas_left).offset((6+40)*i);
            make.height.equalTo(@24);
            make.width.equalTo(@40);
            make.centerY.equalTo(_scrollView.mas_centerY);
            if (i == _priceArray.count-1)
            {
                make.right.equalTo(_scrollView.mas_right).offset(-10);
            }
        }];
    }
    _viewArray = [NSArray arrayWithArray:buttonArray];
    [buttonArray removeAllObjects];
    buttonArray = nil;
    
    
    [self selectTagButton:0 keyName:@"9999"];
}
// 时间选择
- (void)addTimeView
{
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:startButton];
    
    UILabel *startLabel = [[UILabel alloc] init];
    startLabel.text = @"开始时间";
    startLabel.textColor = [UIColor grayColor];
    startLabel.font = [UIFont systemFontOfSize:12];
    [_bottomView addSubview:startLabel];
    
    UILabel *centerLabel = [[UILabel alloc] init];
    centerLabel.textColor = [UIColor blackColor];
    centerLabel.text = @"至";
    centerLabel.font = [UIFont systemFontOfSize:13];
    [_bottomView addSubview:centerLabel];
    
    
    UIButton *endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [endButton addTarget:self action:@selector(endTimeSelect:) forControlEvents:UIControlEventTouchUpInside];
    endButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:endButton];
    
    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.text = @"结束时间";
    endLabel.textColor = [UIColor grayColor];
    endLabel.font = [UIFont systemFontOfSize:12];
    [_bottomView addSubview:endLabel];
    
    _viewArray = [NSArray arrayWithObjects:startButton,endButton, nil];
    
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(_bottomView.mas_left).offset(10);
    }];
    [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(startButton.mas_right).offset(2);
    }];
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(startLabel.mas_right).offset(6);
    }];
    [endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(centerLabel.mas_right).offset(6);
    }];
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(endButton.mas_right).offset(2);
    }];
}
#pragma mark --buttonClick ---
- (void)oneButtonClick:(UIButton *)send
{
    if (_viewType != PreferentialListTypeAmount)
    {
        [self selectNumberButtonState:send.tag];
        
        if (_viewType == PreferentialListTypeNumber)
        {
            if (_delegateFlags.typeNumber)
            {
                [_delegate theNumberOf:_textField.text];
            }
        }
        else
        {
            if (_delegateFlags.typeRules)
            {
                [_delegate usingRulesAmount:_textField.text];
            }
        }
        
    }
}
- (void)twoButtonClick:(UIButton *)send
{
    [self selectNumberButtonState:send.tag];
    
    if (_viewType == PreferentialListTypeNumber)
    {
        if (_delegateFlags.typeNumber)
        {
            [_delegate theNumberOf:@"99999"];
        }
    }
    else
    {
        if (_delegateFlags.typeRules)
        {
            [_delegate usingRulesAmount:@"0"];
        }
    }
}
- (void)selectNumberButtonState:(NSInteger)tag
{
    [_viewArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (tag == obj.tag)
        {
            [obj setImage:[UIImage imageNamed:imageHighlighted] forState:UIControlStateNormal];
        }
        else
        {
            [obj setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
        }
    }];
}
- (void)selectAmountButton:(UIButton *)send
{
    
    NSInteger tag = send.tag - 1000;
    if (tag<_priceArray.count)
    {
        [self selectTagButton:tag keyName:@"9999"];
        if (_delegateFlags.typeAmount)
        {
            NSString *price = _priceArray[tag];
            price = [price stringByReplacingOccurrencesOfString:_isCard?@"折":@"元" withString:@""];
            [self.delegate theAmountSize:@{@"number":price,@"type":@"money"}];
        }
    }
}
- (void)endTimeSelect:(UIButton *)send
{
    TBWeakSelf
    WSDatePickerView *pickerView = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
        
        NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd"];
        [send setTitle:date forState:UIControlStateNormal];
        
        if (_delegateFlags.typeLimit)
        {
            [weakSelf.delegate usingPeriodOfTime:date];
        }
    }];
    if (send.titleLabel.text.length>0)
    {
        pickerView.scrollToDate = [NSDate date:send.titleLabel.text WithFormat:@"yyyy-MM-dd"];
    }
    pickerView.minLimitDate = [NSDate new];
    pickerView.doneButtonColor = NAVIGATION_COLOR;//确定按钮的颜色
    [pickerView show];
    
    
}
#pragma mark ---逻辑处理---
- (void)selectTagButton:(NSInteger)tag keyName:(NSString *)key
{
    if (tag<_viewArray.count)
    {
        _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, 24);
        _textField.text = @"";
        UIButton *preButton = _viewArray[tag];
        CGRect bounds = _scrollView.bounds;
        float offsetX = CGRectGetMinX(preButton.frame);
        bounds.origin.x = offsetX;
        bounds.origin.y = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_scrollView scrollRectToVisible:bounds animated:YES];
        });
    }
    
    NSString *name = [NSString stringWithFormat:@"%@%@",key,_isCard?@"折":@"元"];
    [_viewArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ((obj.tag-1000) == tag ||obj.titleLabel.text.floatValue == name.floatValue)
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
#pragma mark --- UITextFieldDelegate ---
// 禁止文本其它操作
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (_viewType == PreferentialListTypeAmount)
    {
        if (_isCard == YES)
        {
            NSString *str = textField.text;
            double pre = str.doubleValue;
            
            if (pre > 10 || pre < 0) {
                
                hudShowError(@"折扣不能大于10或等于0");
                return NO;
            }
            
        }
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    
    if (textField.text.length > 0)
    {
        if (_viewType == PreferentialListTypeAmount)
        {
            if (_isCard == YES && textField.text.doubleValue == 0)
            {
                hudShowError(@"折扣必须大于0折!");
                textField.text = @"";
            }
            else
            {
                [self selectTagButton:1000 keyName:@"9999"];

            }
            if (_delegateFlags.typeAmount)
            {
                [self.delegate theAmountSize:@{@"number":textField.text,@"type":@"selfmoney"}];
            }
        }
        else if (_viewType == PreferentialListTypeNumber)
        {
            UIButton *button = _viewArray.firstObject;
            [self selectNumberButtonState:button.tag];
            if (_delegateFlags.typeNumber)
            {
                [self.delegate theNumberOf:textField.text];
            }
        }
        else if (_viewType == PreferentialListTypeRules)
        {
            UIButton *button = _viewArray.firstObject;
            [self selectNumberButtonState:button.tag];
            
            if (_delegateFlags.typeRules)
            {
                [self.delegate usingRulesAmount:textField.text];
            }
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (_viewType == PreferentialListTypeAmount)
    {
        if (_isCard == YES)
        {
            NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
            
            double pre = str.doubleValue;
            
            if (pre > 10 || pre < 0) {
                
                hudShowError(@"折扣格式不对!");
                return NO;
            }
        }
        else
        {
            if (textField.text.length == 0)
            {
                if (string.integerValue == 0)
                {
                    hudShowError(@"第一位数字必须大于0");
                    return NO;
                }
            }
        }
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (![ZKUtil ismoney:toBeString] && toBeString.length>0)
    {
        hudShowError(@"格式不对");
        return NO;
    }
    
    return YES;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
