//
//  TBEarningsDateSelectionView.m
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBEarningsDateSelectionView.h"
#import "ZKPickerViewCell.h"
#define contentHeight 240
#define MIN_DATA  2017
#define MIN_MONTH  7
@interface TBEarningsDateSelectionView()<UIPickerViewDataSource,UIPickerViewDelegate>

@end
@implementation TBEarningsDateSelectionView
{
    UILabel *promptLabel;
    UIPickerView *_picker;
    UIView *contentView;
    NSInteger index;
    NSMutableArray *yearsArray;
    NSMutableArray *monthArray;
    NSArray        *selectMonthArray;
    
    NSInteger yearsKey;
    NSInteger monthKey;
    
}
- (instancetype)init
{
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH-100, contentHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 4;
        [self addSubview:contentView];
        
        promptLabel = [[UILabel alloc] init];
        promptLabel.textColor = RGB(70, 71, 72);
        promptLabel.font = [UIFont systemFontOfSize:16];
        promptLabel.textAlignment = NSTextAlignmentCenter;
        promptLabel.text = @" 年  月";
        [contentView addSubview:promptLabel];
        
        UIView *promptLinView = [[UIView alloc] init];
        promptLinView.backgroundColor = BODER_COLOR;
        [contentView addSubview:promptLinView];
        
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 40, _SCREEN_WIDTH-20, contentHeight-44)];
        _picker.delegate   = self;
        _picker.dataSource = self;
        // 显示选中的指示器
        _picker.showsSelectionIndicator = YES;
        [contentView addSubview:_picker];
        
        
        UIView *footView = [[UIView alloc] init];
        footView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:footView];
        
        UIButton *cancelBty = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBty setTitle:@"取 消" forState:UIControlStateNormal];
        [cancelBty setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        cancelBty.titleLabel.font = [UIFont systemFontOfSize:16];
        cancelBty.backgroundColor = [UIColor whiteColor];
        [cancelBty addTarget:self action:@selector(determineClick) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:cancelBty];
        
        UIButton *determineBty = [UIButton buttonWithType:UIButtonTypeCustom];
        [determineBty setTitle:@"确 定" forState:UIControlStateNormal];
        [determineBty setTitleColor:NAVIGATION_COLOR forState:UIControlStateNormal];
        determineBty.titleLabel.font = [UIFont systemFontOfSize:16];
        determineBty.backgroundColor = [UIColor whiteColor];
        [determineBty addTarget:self action:@selector(senderClick) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:determineBty];
        
        
        UIView *linTopView = [[UIView alloc] init];
        linTopView.backgroundColor = BODER_COLOR;
        [footView addSubview:linTopView];
        
        UIView *linView = [[UIView alloc] init];
        linView.backgroundColor = BODER_COLOR;
        [footView addSubview:linView];
        
        TBWeakSelf
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).offset(40);
            make.right.equalTo(weakSelf.mas_right).offset(-40);
            make.height.mas_equalTo(contentHeight);
            make.center.equalTo(weakSelf);
        }];
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(contentView);
            make.height.equalTo(@44);
        }];
        
        [promptLinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(promptLabel.mas_bottom);
            make.left.equalTo(contentView.mas_left).offset(10);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.height.equalTo(@0.5);
        }];
        [_picker mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(contentView);
            make.top.equalTo(promptLinView.mas_bottom);
            make.bottom.equalTo(footView.mas_top);
        }];
        [footView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(contentView);
            make.height.equalTo(@55);
            make.bottom.equalTo(contentView.mas_bottom);
        }];
        
        [linView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footView);
            make.width.equalTo(@0.5);
            make.height.equalTo(@40);
        }];
        
        [cancelBty mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(footView);
            make.right.equalTo(linView.mas_left);
        }];
        
        [determineBty mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(footView);
            make.left.equalTo(linView.mas_left);
        }];
        
        [linTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footView);
            make.left.equalTo(footView.mas_left).offset(10);
            make.right.equalTo(footView.mas_right).offset(-10);
            make.height.equalTo(@0.5);
        }];
        
    }
    return self;
}

/**
 核心代码 数据添加
 */
- (void)calculateTheDate
{
    yearsArray = [NSMutableArray array];
    monthArray = [NSMutableArray array];
    //实例化一个NSDateFormatter对象
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    if (![currentDateStr isKindOfClass:[NSString class]])
    {
        return;
    }
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
    NSInteger years = [dateArray.firstObject integerValue];
    NSInteger month = [dateArray.lastObject integerValue];
    
    // 循环每年
    for (int i = 0; i<(years-MIN_DATA)+1; i++)
    {
        NSInteger newYears = years-i;
        [yearsArray addObject:[NSNumber numberWithInteger:newYears]];
        NSMutableArray *recordArray = [NSMutableArray array];
        if (newYears == MIN_DATA && (years-MIN_DATA) >0)
        {  //最小年 且现年大于最小年MIN_DATA
            for (int j = 0; j < (12 - MIN_MONTH + 1); j++)
            {
                [recordArray addObject:[NSNumber numberWithInteger:MIN_MONTH+j]];
            }
        }
        else if (newYears == years)
        {   //今年  如果今年是最小年  月基数就是MIN_MONTH
            int baseMonth = (years-MIN_DATA) == 0?MIN_MONTH:1;
            for (int k = baseMonth; k < month+1; k++)
            {
                
                [recordArray addObject:[NSNumber numberWithInteger:k]];
            }
        }
        else
        {
            // 中间年月数
            [recordArray addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"]];
        }
        [monthArray addObject:recordArray];
    }
    selectMonthArray = monthArray.firstObject;
    yearsKey = [yearsArray.firstObject integerValue];
    monthKey = [selectMonthArray.lastObject integerValue];
    [_picker reloadAllComponents];
    [_picker selectRow:selectMonthArray.count-1 inComponent:1 animated:YES];
    [self upHeaderlabelText];
    
}
- (void)upHeaderlabelText
{
    promptLabel.text = [NSString stringWithFormat:@"%ld年%ld月",(long)yearsKey,(long)monthKey];
}
#pragma mark picker代理
// 设置pickerView中有几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
// 设置每一列中有几行
// 这个协议方法  不是只调用一次, 有几列调用几次
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return yearsArray.count;
    }
    return selectMonthArray.count;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    ZKPickerViewCell *pickerCell = (ZKPickerViewCell *)view;
    if (!pickerCell) {
        pickerCell = [[ZKPickerViewCell alloc] initWithFrame:(CGRect){CGPointZero, pickerView.frame.size.width/2-10, 60} ];
    }
    pickerCell.label.font = [UIFont systemFontOfSize:18];
    pickerCell.label.font = [UIFont boldSystemFontOfSize:18];
    pickerCell.backgroundColor = [UIColor whiteColor];
    
    if (component == 0)
    {
        pickerCell.label.text = [NSString stringWithFormat:@"%@",[yearsArray objectAtIndex:row]];
    }
    else
    {
        pickerCell.label.text = [NSString stringWithFormat:@"%@",[selectMonthArray objectAtIndex:row]];
    }
    return pickerCell;
}
// 当选中某一行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        //选中省份表盘时，根据row的值改变城市数组，刷新城市数组
        yearsKey         = [[yearsArray objectAtIndex:row] integerValue];
        selectMonthArray = monthArray[row];
        [_picker reloadComponent:1];
        NSInteger rowTwo = [_picker selectedRowInComponent:1];
        monthKey = [[selectMonthArray objectAtIndex:rowTwo] integerValue];
        
    }
    else
    {
        monthKey = [[selectMonthArray objectAtIndex:row] integerValue];
        
    }
    [self upHeaderlabelText];
}
#pragma mark  点击事件啊
- (void)senderClick
{
    if (yearsKey>0 && monthKey >0 && self.selectionDate)
    {
        NSString *month;
        if (monthKey < 10)
        {
            month = [NSString stringWithFormat:@"0%ld",(long)monthKey];
        }
        else
        {
            month = [NSString stringWithFormat:@"%ld",(long)monthKey];
        }
        self.selectionDate([NSString stringWithFormat:@"%ld-%@",(long)yearsKey,month]);
    }
    [self backClick];
}

- (void)determineClick
{
    [self backClick];
    
}
- (void)backClick
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

- (void)show;
{
    [[APPDELEGATE window] addSubview:self];
    contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            contentView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
            [self calculateTheDate];
        }];
    }];
    
    
}


@end
