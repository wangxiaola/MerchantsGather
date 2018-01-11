//
//  TBPreferentialStatusView.m
//  Telecom
//
//  Created by 王小腊 on 2017/9/1.
//  Copyright © 2017年 王小腊. All rights reserved.
//
static NSString *const imageHighlighted = @"task-choice-hover";
static NSString *const imageNormal = @"task-choice";
#import "TBPreferentialStatusView.h"

@implementation TBPreferentialStatusView
{
    UIButton *_stateButton;
}
- (instancetype)initPromptString:(NSString *)prompt;
{
    if (self = [super init])
    {
        [self createViewPromptString:prompt];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}
- (void)createViewPromptString:(NSString *)prompt;
{

    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.text = prompt;
    [self addSubview:infoLabel];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.textColor = [UIColor grayColor];
    promptLabel.font = [UIFont systemFontOfSize:13];
    promptLabel.text = @"（不发布请取消勾选）";
    [self addSubview:promptLabel];
    
    _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_stateButton setImage:[UIImage imageNamed:imageHighlighted] forState:UIControlStateNormal];
    [_stateButton addTarget:self action:@selector(stateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _stateButton.selected = YES;
    [self addSubview:_stateButton];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoLabel.mas_right);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
}
- (void)setSelectButtonState:(BOOL)state;
{
    NSString *imageName = state?imageHighlighted:imageNormal;
    [_stateButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    _stateButton.selected = state;

}
#pragma mark  ----按钮点击事件----
- (void)stateButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    NSString *imageName = sender.selected?imageHighlighted:imageNormal;
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (self.preferentialStatus)
    {
        self.preferentialStatus(sender.selected);
    }
}
@end
