//
//  TBMoreReminderView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBMoreReminderView.h"

@implementation TBMoreReminderView
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
        
        UIView *promptBackView = [[UIView alloc] init];
        promptBackView.backgroundColor = NAVIGATION_COLOR;
        [contentView addSubview:promptBackView];
        
        UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReminderImage"]];
        [promptBackView addSubview:promptImageView];
        
        UILabel *updataLabel = [[UILabel alloc] init];
        updataLabel.text = @"温馨提示";
        updataLabel.textColor = [UIColor whiteColor];
        updataLabel.font = [UIFont systemFontOfSize:18 weight:0.2];
        [promptBackView addSubview:updataLabel];
        
        UILabel *promptLabel = [[UILabel alloc] init];
        promptLabel.textColor = RGB(70, 71, 72);
        promptLabel.font = [UIFont systemFontOfSize:16];
        promptLabel.numberOfLines = 0;
        promptLabel.text = prompt;
        [contentView addSubview:promptLabel];
        
        UIView *footView = [[UIView alloc] init];
        footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [contentView addSubview:footView];
        
        UIView *linTopView = [[UIView alloc] init];
        linTopView.backgroundColor = BODER_COLOR;
        [footView addSubview:linTopView];
        
        UIView *linView = [[UIView alloc] init];
        linView.backgroundColor = BODER_COLOR;
        [footView addSubview:linView];
        
        UIButton *lefButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [lefButton setTitle:@"取 消" forState:UIControlStateNormal];
        lefButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [lefButton setTitleColor:RGB(70, 71, 72) forState:UIControlStateNormal];
        [lefButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:lefButton];
        
        UIButton *ritButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ritButton setTitle:@"确 定" forState:UIControlStateNormal];
        ritButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [ritButton setTitleColor:NAVIGATION_COLOR forState:UIControlStateNormal];
        [ritButton addTarget:self action:@selector(updataButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:ritButton];
        
        TBWeakSelf
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).offset(40);
            make.right.equalTo(weakSelf.mas_right).offset(-40);
            make.center.equalTo(weakSelf);
        }];
        
        [promptBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(contentView);
            make.height.equalTo(@50);
        }];
        
        [promptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(promptBackView.mas_centerY);
            make.left.equalTo(@16);
        }];
        
        [updataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(promptImageView.mas_right).offset(14);
            make.centerY.equalTo(promptBackView.mas_centerY);
        }];
        
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(16);
            make.right.equalTo(contentView.mas_right).offset(-16);
            make.top.equalTo(promptBackView.mas_bottom).offset(16);
            make.height.mas_greaterThanOrEqualTo(44);
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
- (void)cancelButtonClick:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    if (self.cancel)
    {
        self.cancel();
    }
    [self hideView];
}
- (void)updataButtonClick:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    if (self.determine)
    {
        self.determine();
    }
    [self hideView];
}
#pragma mark ---view--

- (void)cancelClick:(cancel)cancel;
{
    self.cancel = cancel;
}
-(void)showHandler:(determine)change;
{
    self.alpha = 1;
    self.determine = change;
    
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
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];

}

@end
