//
//  ZKPickDateView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKPickDataView.h"
#import "ZKPickerViewCell.h"
#import "TBBasicDataTool.h"

#define contentHeight 280

@implementation ZKPickDataView
{
    
    UIPickerView *_picker;
    UIView *contentView;
    NSArray *_array;
    NSInteger index;
    PickDataViewType _dataType;
    UIButton *headerView;
}
- (instancetype)init
{
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];;
        
        UIButton *hideButton = [[UIButton alloc] initWithFrame:self.bounds];
        hideButton.backgroundColor = [UIColor clearColor];
        [hideButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hideButton];
        
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, contentHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 40, _SCREEN_WIDTH-20, contentHeight-44)];
        _picker.delegate = self;
        _picker.dataSource = self;
        // 显示选中的指示器
        _picker.showsSelectionIndicator = YES;
        [contentView addSubview:_picker];
        
        headerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, 40)];
        headerView.backgroundColor = RGB(209, 209, 209);
        [headerView setTitle:@"商家类型" forState:UIControlStateNormal];
        headerView.titleLabel.font = [UIFont systemFontOfSize:16 weight:0.1];
        [headerView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [contentView addSubview:headerView];
        
        UIButton *cancelBty = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBty setTitle:@"取 消" forState:UIControlStateNormal];
        [cancelBty setTitleColor:NAVIGATION_COLOR forState:UIControlStateNormal];
        cancelBty.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelBty.backgroundColor = [UIColor clearColor];
        [cancelBty addTarget:self action:@selector(determineClick) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:cancelBty];
        
        UIButton *determineBty = [UIButton buttonWithType:UIButtonTypeCustom];
        [determineBty setTitle:@"确 定" forState:UIControlStateNormal];
        [determineBty setTitleColor:NAVIGATION_COLOR forState:UIControlStateNormal];
        determineBty.titleLabel.font = [UIFont systemFontOfSize:15];
        determineBty.backgroundColor = [UIColor clearColor];
        [determineBty addTarget:self action:@selector(senderClick) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:determineBty];
        
        [cancelBty mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(headerView.mas_left).offset(20);
            make.centerY.mas_equalTo(headerView.mas_centerY);
        }];
        
        [determineBty mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(headerView.mas_right).offset(-20);
            make.centerY.mas_equalTo(headerView.mas_centerY);
        }];
        
        
    }
    
    return self;
    
}
- (instancetype)initData:(NSArray*)cellArray typeName:(NSString *)name type:(PickDataViewType)type;
{
    self =[self init];
    if (self) {
        _dataType = type;
        _array = cellArray;
        [_picker reloadAllComponents];
        [headerView setTitle:name forState:UIControlStateNormal];
    }
    
    return self;
}


- (instancetype)initAreaData:(NSArray<TBBasicDataArea *>*)cellArray;
{
    self =[self init];
    if (self) {
        
        _array = cellArray;
        [_picker reloadAllComponents];
        [headerView setTitle:@"区域选择" forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark picker代理
// 设置pickerView中有几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// 设置每一列中有几行
// 这个协议方法  不是只调用一次, 有几列调用几次
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _array.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    ZKPickerViewCell *pickerCell = (ZKPickerViewCell *)view;
    if (!pickerCell) {
        pickerCell = [[ZKPickerViewCell alloc] initWithFrame:(CGRect){CGPointZero, pickerView.frame.size.width/2-10, 60} ];
    }
    
    if (_dataType == PickDataViewTypeMerchants) {
        
        TBBasicDataShoptypes *data = _array[row];
        pickerCell.label.text = data.name;
    }
    else if (_dataType == PickDataViewTypeArea)
    {
        TBBasicDataArea *data = _array[row];
        pickerCell.label.text = data.name;
    }
    else if (_dataType == PickDataViewTypeBank)
    {
        TBBankMerchantsTypeData *data = _array[row];
        pickerCell.label.text = data.shop_class_name;
    }
    
    return pickerCell;
}
// 当选中某一行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    index = row;
}
#pragma mark  点击事件啊
- (void)senderClick
{
    if ([self.delegate respondsToSelector:@selector(selectedData:)]&&index<_array.count&&_array.count>0) {
        
        [self.delegate selectedData:_array[index]];
    }
    [self backClick];
}

- (void)determineClick
{
    
    [self backClick];
    
}

- (void)backClick
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        contentView.frame = CGRectMake(0, _SCREEN_HEIGHT+contentHeight,_SCREEN_WIDTH, contentHeight);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

- (void)showSelectedData:(NSInteger)data;
{
    self.alpha = 1;
    __block NSInteger selectedCell = 0;
    
    [_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (_dataType == PickDataViewTypeMerchants) {
            TBBasicDataShoptypes *mode = obj;
            if (mode.ID == data)
            {
                selectedCell = idx;
            }
        }
        else if (_dataType == PickDataViewTypeArea)
        {
            TBBasicDataArea *area = obj;
            if (area.code.integerValue == data)
            {
                selectedCell = idx;
            }
        }
        else if (_dataType == PickDataViewTypeBank)
        {
            TBBankMerchantsTypeData *type = obj;
            if (type.ID == data)
            {
                selectedCell = idx;
            }
        }
        
        
    }];
    index = selectedCell;
    [self showSelected:selectedCell];
}

- (void)showSelected:(NSInteger)row;
{
    [[APPDELEGATE window] addSubview:self];
    contentView.frame = CGRectMake(0, _SCREEN_HEIGHT+contentHeight,_SCREEN_WIDTH, contentHeight);
    [UIView animateWithDuration:0.3 animations:^{
        
        contentView.frame = CGRectMake(0, _SCREEN_HEIGHT-contentHeight,_SCREEN_WIDTH, contentHeight);
        [_picker selectRow:row inComponent:0 animated:YES];
    }];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
