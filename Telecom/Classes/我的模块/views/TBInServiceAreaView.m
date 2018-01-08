//
//  TBInServiceAreaView.m
//  Telecom
//
//  Created by 王小腊 on 2017/5/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBInServiceAreaView.h"

@implementation TBInServiceAreaView
{
    UIButton *_promptButton;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        _promptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_promptButton setImage:[UIImage imageNamed:@"task_bt"] forState:UIControlStateNormal];
        [_promptButton setTitle:@"  " forState:UIControlStateNormal];
        [_promptButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _promptButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_promptButton];
        TBWeakSelf
        [_promptButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.mas_left).offset(8);
            make.top.bottom.equalTo(weakSelf);
        }];

    }
    return self;
}
- (void)headAssignment:(NSString *)name;
{

    [_promptButton setTitle:[NSString stringWithFormat:@" %@",name] forState:UIControlStateNormal];
}

@end
