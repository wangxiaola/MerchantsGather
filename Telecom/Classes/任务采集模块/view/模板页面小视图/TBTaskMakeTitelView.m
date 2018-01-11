//
//  TBTaskMakeTitelView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/17.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBTaskMakeTitleView.h"

@implementation TBTaskMakeTitleView
{
    
    UIView *_centerView;
    UILabel *_lefLabel;
    UILabel *_ritLebel;
    
    NSString *_type;
    
}
- (NSMutableArray<NSDictionary *> *)titelArray
{
    if (!_titelArray) {
        _titelArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _titelArray;
}
#pragma mark  ----init----
/**
 创建
 
 @param frame 尺寸
 @param type 类型
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame type:(NSString *)type;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        _type = type;
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_centerView];
        
        _lefLabel = [[UILabel alloc] init];
        _lefLabel.text = @"数据正在加载...";
        _lefLabel.textColor = [UIColor whiteColor];
        _lefLabel.font = [UIFont systemFontOfSize:16 weight:0.2];
        [_centerView addSubview:_lefLabel];
        
        _ritLebel = [[UILabel alloc] init];
        _ritLebel.text = @"";
        _ritLebel.textColor = [UIColor whiteColor];
        _ritLebel.font = [UIFont systemFontOfSize:13 weight:0.2];
        [_centerView addSubview:_ritLebel];
        TBWeakSelf
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(weakSelf);
            make.centerX.equalTo(weakSelf.mas_centerX);
        }];
        
        [_lefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_centerView);
            make.centerY.equalTo(_centerView.mas_centerY);
        }];
        
        [_ritLebel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_centerView);
            make.left.equalTo(_lefLabel.mas_right).offset(4);
            make.bottom.equalTo(_lefLabel.mas_bottom);
        }];
    }
    
    return self;
    
}

/**
 选中第几个
 
 @param index row
 */
- (void)selectIndex:(NSInteger)index;
{
    if (index > self.titelArray.count)
    {
        return;
    }
    NSDictionary *dic = self.titelArray[index];
    _lefLabel.text = [self assembleName:dic[@"name"]];
    _ritLebel.text = dic[@"prompt"];
    
}
- (NSString *)assembleName:(NSString *)name
{
    NSString *nameString = name;
    NSString *typeName = @"";
    
    if ([_type isEqualToString:@"farmstay"])
    {
        typeName = @"农家乐";
    }
    else if ([_type isEqualToString:@"recreation"])
    {
        typeName = @"休闲娱乐";
    }
    else if ([_type isEqualToString:@"food"])
    {
        typeName = @"特色美食";
    }
    else if ([_type isEqualToString:@"hotel"])
    {
        typeName = @"酒店客栈";
    }
    else if ([_type isEqualToString:@"view"])
    {
        typeName = @"景区景点";
    }
    else
    {
        typeName = @"服务场所";
    }
    nameString = [NSString stringWithFormat:@"%@-%@",typeName,name];
    
    return nameString;
}
@end
