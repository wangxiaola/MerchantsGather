//
//  TBRegionChooseView.m
//  Telecom
//
//  Created by 王小腊 on 2017/7/17.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBRegionChooseView.h"
#import "TBRegionESRootClass.h"
#import "ZKPickerViewCell.h"

#define contentHeight 280

@interface TBRegionChooseView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) NSArray <TBRegionData *>*provinces;//展示省份
@property (nonatomic, strong) NSArray <TBRegionCityChildren *>*cityChildrens;//展示市
@property (nonatomic, strong) NSArray <TBRegionAreaChildren *>*areaChildrens;//展示区域
@end
@implementation TBRegionChooseView
{
    UIPickerView *_picker;
    UIView *contentView;
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
        [headerView setTitle:@"区域选择" forState:UIControlStateNormal];
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
- (instancetype)initRegionData:(TBRegionESRootClass *)data;
{
    self =[self init];
    if (self) {
        
        self.provinces = data.data;
        if (data.data.count > 0)
        {
            TBRegionData *list = data.data.firstObject;
            self.cityChildrens = list.children;
            
            if (list.children.count > 0)
            {
                TBRegionCityChildren *cityChildren = list.children.firstObject;
                self.areaChildrens = cityChildren.children;
            }
        }
        
        [_picker reloadAllComponents];
    }
    
    return self;
    
}
#pragma mark picker代理
// 设置pickerView中有几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger  section = 0;
    
    if (self.provinces.count > 0)
    {
        section += 1;
    }
    if (self.cityChildrens.count > 0)
    {
        section += 1;
    }
    if (self.areaChildrens.count > 0)
    {
        section += 1;
    }
    
    return section;
}
// 设置每一列中有几行
// 这个协议方法  不是只调用一次, 有几列调用几次
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.provinces.count;
    }
    else if (component == 1)
    {
        return self.cityChildrens.count;
    }
    return self.areaChildrens.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    ZKPickerViewCell *pickerCell = (ZKPickerViewCell *)view;
    if (!pickerCell) {
        pickerCell = [[ZKPickerViewCell alloc] initWithFrame:(CGRect){CGPointZero, pickerView.frame.size.width/pickerView.numberOfComponents-10, 60} ];
    }
    
    if (component == 0)
    {
        TBRegionData *data = [self.provinces objectAtIndex:row];
        pickerCell.label.text = data.name;
    }
    else if (component == 1)
    {
        TBRegionCityChildren *children = [self.cityChildrens objectAtIndex:row];
        pickerCell.label.text = children.name;
    }
    else if (component == 2)
    {
        TBRegionAreaChildren *children = [self.areaChildrens objectAtIndex:row];
        pickerCell.label.text = children.name;
    }
    return pickerCell;
}
// 当选中某一行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        TBRegionData *data = self.provinces[row];
        if (data.children.count > 0)
        {
            self.cityChildrens = data.children;
            
            TBRegionCityChildren *cityChildren = self.cityChildrens.firstObject;
            if (cityChildren.children.count > 0)
            {
                self.areaChildrens = cityChildren.children;
            } else {
                self.areaChildrens = nil;
            }
        }
        else
        {
            self.cityChildrens = nil;
            self.areaChildrens = nil;
        }
        
        [pickerView reloadAllComponents];
    }
    
    if (component == 1)
    {
        TBRegionCityChildren *cityChildren = self.cityChildrens[row];
        if (cityChildren.children.count > 0)
        {
            self.areaChildrens = cityChildren.children;
        } else {
            self.areaChildrens = nil;
        }
        [pickerView reloadAllComponents];
    }
    
}

#pragma mark  点击事件啊
- (void)senderClick
{
    NSString *selectedCode = @"";
    NSString *selectedName = @"";
    
    if (self.areaChildrens.count >0)
    {
        TBRegionAreaChildren *areaChildren = [self.areaChildrens objectAtIndex:[_picker selectedRowInComponent:2]];
        selectedCode = areaChildren.code;
        selectedName = areaChildren.name;
    }
    else if (self.cityChildrens.count >0)
    {
        TBRegionCityChildren *cityChildren = [self.cityChildrens objectAtIndex:[_picker selectedRowInComponent:1]];
        selectedCode = cityChildren.code;
        selectedName = cityChildren.name;
        
    }
    else if (self.provinces.count >0)
    {
        TBRegionData *data = [self.provinces objectAtIndex:[_picker selectedRowInComponent:0]];
        selectedCode = data.code;
        selectedName = data.name;
    }
    if ([self.delegate respondsToSelector:@selector(selectedRegionName:RegionCode:)]) {
        [self.delegate selectedRegionName:selectedName RegionCode:selectedCode];
    }
    
    NSInteger componentA = self.provinces.count == 0?0:[_picker selectedRowInComponent:0];
    NSInteger componentB = self.cityChildrens.count == 0?0:[_picker selectedRowInComponent:1];
    NSInteger componentC = self.areaChildrens.count == 0?0:[_picker selectedRowInComponent:2];
    
    if ([self.delegate respondsToSelector:@selector(selectedProvincesComponent:)]) {
        [self.delegate selectedProvincesComponent:ChooseViewComponentMake(componentA, componentB, componentC)];
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
- (void)showSelectedRegionComponent:(ChooseViewComponent)chooseViewComponent;
{
    TBRegionData *data = self.provinces[chooseViewComponent.provincesIndex];
    self.cityChildrens = data.children;
    
    if (self.cityChildrens.count >0)
    {
        TBRegionCityChildren *cityChildren = self.cityChildrens[chooseViewComponent.cityIndex];
        self.areaChildrens = cityChildren.children;
    }
    else
    {
        self.areaChildrens = nil;
    }
    [self showViewUpdataProvincesRow:chooseViewComponent.provincesIndex childrenRow:chooseViewComponent.cityIndex areaRow:chooseViewComponent.areaIndex];
}
- (void)showViewUpdataProvincesRow:(NSInteger)provincesRow childrenRow:(NSInteger)childrenRow areaRow:(NSInteger)areaRow;
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        self.alpha = 1;
        [[APPDELEGATE window] addSubview:self];
        contentView.frame = CGRectMake(0, _SCREEN_HEIGHT+contentHeight,_SCREEN_WIDTH, contentHeight);
        [UIView animateWithDuration:0.3 animations:^{
            
            contentView.frame = CGRectMake(0, _SCREEN_HEIGHT-contentHeight,_SCREEN_WIDTH, contentHeight);
            [_picker selectRow:provincesRow inComponent:0 animated:YES];
            if (self.cityChildrens.count > 0)
            {
                [_picker selectRow:childrenRow inComponent:1 animated:YES];
            }
            if (self.areaChildrens.count > 0)
            {
                [_picker selectRow:areaRow inComponent:2 animated:YES];
            }
        }];
        
    }];
}

@end
