//
//  TBUpdateTooltipView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBUpdateTooltipView.h"

@implementation TBUpdateTooltipView
{
    UIView *contentView;
}
- (instancetype)initShowPrompt:(NSString *)prompt;
{
    
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.masksToBounds = YES;
        contentView.clipsToBounds = YES;
        contentView.layer.cornerRadius = 4;
        [self addSubview:contentView];
        
        UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"updataLog"]];
        [contentView addSubview:promptImageView];
        
        UILabel *updataLabel = [[UILabel alloc] init];
        updataLabel.text = @"版本更新";
        updataLabel.textColor = [UIColor blackColor];
        updataLabel.font = [UIFont systemFontOfSize:18 weight:0.2];
        [contentView addSubview:updataLabel];
        
        UILabel *promptLabel = [[UILabel alloc] init];
        promptLabel.textColor = RGB(70, 71, 72);
        promptLabel.font = [UIFont systemFontOfSize:16];
        promptLabel.numberOfLines = 0;
        promptLabel.text = prompt;
        promptLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:promptLabel];
        
        UIView *footView = [[UIView alloc] init];
        footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [contentView addSubview:footView];
        
        UIView *linView = [[UIView alloc] init];
        linView.backgroundColor = BODER_COLOR;
        [footView addSubview:linView];
        
        UIView *linTopView = [[UIView alloc] init];
        linTopView.backgroundColor = BODER_COLOR;
        [footView addSubview:linTopView];
        
        UIButton *lefButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [lefButton setTitle:@"下次再说" forState:UIControlStateNormal];
        lefButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [lefButton setTitleColor:RGB(70, 71, 72) forState:UIControlStateNormal];
        [lefButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:lefButton];
        
        UIButton *ritButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ritButton setTitle:@"立即更新" forState:UIControlStateNormal];
        ritButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [ritButton setTitleColor:NAVIGATION_COLOR forState:UIControlStateNormal];
        [ritButton addTarget:self action:@selector(updataClick) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:ritButton];
        
        TBWeakSelf
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).offset(40);
            make.right.equalTo(weakSelf.mas_right).offset(-40);
            make.center.equalTo(weakSelf);
        }];
        
        [promptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView.mas_centerX);
            make.top.equalTo(@20);
        }];
        
        [updataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(promptImageView.mas_bottom).offset(20);
            make.centerX.equalTo(contentView.mas_centerX);
        }];
        
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(20);
            make.right.equalTo(contentView.mas_right).offset(-20);
            make.top.equalTo(updataLabel.mas_bottom).offset(16);
        }];
        
        [footView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(promptLabel.mas_bottom).offset(16);
            make.left.right.equalTo(contentView);
            make.height.equalTo(@55);
            make.bottom.equalTo(contentView.mas_bottom);
        }];
        
        [linView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footView);
            make.width.equalTo(@1);
            make.height.equalTo(@25);
        }];
        
        [lefButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(footView);
            make.right.equalTo(linView.mas_left);
        }];
        
        [ritButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(footView);
            make.left.equalTo(linView.mas_left);
        }];
        [linTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(footView);
            make.height.equalTo(@1);
        }];
    }
    return self;
}
#pragma mark --click --
- (void)cancelClick
{
    [self hideView];
}
- (void)updataClick
{
    [self hideView];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",TELECOM_ID]]];
}
#pragma mark ---view--
-(void)show;
{
    self.alpha = 1;
    
    [[APPDELEGATE window] addSubview:self];
    contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            contentView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }];
}
-(void)hideView{
    
 [self removeFromSuperview];
}
@end
