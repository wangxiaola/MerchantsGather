//
//  TBReturnsBalanceView.m
//  Telecom
//
//  Created by 王小腊 on 2017/9/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBReturnsBalanceView.h"
#import "ScottCounter.h"
#import "TBMoreReminderView.h"
#import "WXApi.h"

@implementation TBReturnsBalanceView
{

    UILabel  *_balanceLabel;
    UIButton *_withdrawalButton;
    
}
- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        UIView *balanceContenView = [[UIView alloc] init];
        balanceContenView.userInteractionEnabled = YES;
        [self addSubview:balanceContenView];
        
        UILabel *promptLabel = [[UILabel alloc] init];
        promptLabel.text = @"收益余额";
        promptLabel.textColor = [UIColor grayColor];
        promptLabel.font = [UIFont systemFontOfSize:14];
        [balanceContenView addSubview:promptLabel];
        
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.text = @"￥0.00";
        _balanceLabel.font = [UIFont systemFontOfSize:19 weight:0.3];
        _balanceLabel.textColor = RGB(228, 55, 0);
        [balanceContenView addSubview:_balanceLabel];
        
        _withdrawalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _withdrawalButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_withdrawalButton setTitle:@"我要提现" forState:UIControlStateNormal];
        [_withdrawalButton setTitleColor:NAVIGATION_COLOR forState:UIControlStateNormal];
        _withdrawalButton.layer.masksToBounds = YES;
        _withdrawalButton.layer.cornerRadius = 15;
        _withdrawalButton.layer.borderColor = NAVIGATION_COLOR.CGColor;
        _withdrawalButton.layer.borderWidth = 0.6;
        _withdrawalButton.backgroundColor = [UIColor whiteColor];
        [_withdrawalButton addTarget:self action:@selector(withdrawalClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_withdrawalButton];
        
        TBWeakSelf
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(balanceContenView);
        }];
        
        [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(balanceContenView.mas_left);
            make.top.equalTo(promptLabel.mas_bottom).offset(10);
            make.bottom.equalTo(balanceContenView.mas_bottom);
        }];
        
        [balanceContenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).offset(20);
            make.centerY.equalTo(weakSelf.mas_centerY);
        }];
        
        [_withdrawalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.mas_right).offset(-20);
            make.bottom.equalTo(_balanceLabel.mas_bottom);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

/**
 更新余额
 
 @param balanceNumber 余额
 */
- (void)updataBalanceNumber:(CGFloat)balanceNumber;
{
    _balanceLabel.animationOptions = ScottCounterAnimationOptionCurveEaseInOut;
    [_balanceLabel scott_fromNumber:0 toNumber:balanceNumber duration:1.0f format:^NSString *(CGFloat number) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.positiveFormat = @"###,##0.00";
        NSNumber *amountNumber = [NSNumber numberWithFloat:number];
        return [NSString stringWithFormat:@"¥%@",[formatter stringFromNumber:amountNumber]];
    }];

}
- (void)withdrawalClick
{
   NSString *msg = @"1、打开微信，搜索关注进入“微网掌柜”公账号\n2、从网格入口进入登录后即可提现到微信钱包";
    TBWeakSelf
    TBMoreReminderView *moreView = [[TBMoreReminderView alloc] initShowPrompt:msg];
    [moreView showHandler:^{
        
        [weakSelf jumpWeChat];
    }];
}

/**
 跳转微信
 */
- (void)jumpWeChat
{
    if ([WXApi isWXAppInstalled] == YES)
    {
        [WXApi openWXApp];
    }
}
@end
