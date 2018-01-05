//
//  TBReviewTipsPopView.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/28.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBReviewTipsPopView.h"

@interface TBReviewTipsPopView ()

@property (nonatomic, strong) UIView *popView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *canceButton;

@end
@implementation TBReviewTipsPopView

- (instancetype)init
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
        self.popView = [[UIView alloc] init];
        self.popView.userInteractionEnabled = YES;
        self.popView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.popView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"审核不通过原因";
        titleLabel.font = [UIFont systemFontOfSize:18 weight:0.2];
        [self.popView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = BODER_COLOR;
        [self.popView addSubview:lineView];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        [self.popView addSubview:self.timeLabel];
        
        self.textView = [[UITextView alloc] init];
        self.textView.editable = NO;
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.shouldGroupAccessibilityChildren = NO;
        self.textView.showsVerticalScrollIndicator = NO;
        self.textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
        self.textView.textColor = [UIColor blackColor];
        self.textView.font = [UIFont systemFontOfSize:14];
        [self.popView addSubview:self.textView];
        
        self.canceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.canceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.canceButton setTitle:@"关 闭" forState:UIControlStateNormal];
        self.canceButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.canceButton.backgroundColor = NAVIGATION_COLOR;
        [self.canceButton addTarget:self action:@selector(shutDownClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.popView addSubview:self.canceButton];
        
        TBWeakSelf
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.left.equalTo(weakSelf.mas_left).offset(50);
            make.right.equalTo(weakSelf.mas_right).offset(-50);
            make.height.mas_equalTo(280);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.popView);
            make.height.mas_equalTo(44);
            make.centerX.equalTo(weakSelf.popView);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom);
            make.left.right.equalTo(self.popView);
            make.height.mas_equalTo(0.5);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.popView.mas_left).offset(8);
            make.top.equalTo(lineView.mas_bottom).offset(8);
            
        }];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.popView);
            make.top.equalTo(weakSelf.timeLabel.mas_bottom);
        }];
        [self.canceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.textView.mas_bottom);
            make.bottom.equalTo(weakSelf.popView.mas_bottom).offset(-8);
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(38);
        }];
        
        self.canceButton.layer.borderColor = BODER_COLOR.CGColor;
        self.canceButton.layer.borderWidth = 0.5;
        self.canceButton.layer.cornerRadius = 4;
        self.layer.borderColor = BODER_COLOR.CGColor;
        self.layer.borderWidth = 0.5;
        self.textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    }
    
    return self;

}
- (void)showTime:(NSString *)time content:(NSString *)info;
{
    self.timeLabel.text = time;
    self.textView.text = info;
    
    [[APPDELEGATE window] addSubview:self];
    self.popView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.popView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.popView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }];

}
- (IBAction)shutDownClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];

}
@end
