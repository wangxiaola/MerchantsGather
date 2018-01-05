//
//  TBUploadPromptHUD.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/26.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBUploadPromptHUD.h"
#import "ASProgressPopUpView.h"

@interface TBUploadPromptHUD ()<ASProgressPopUpViewDataSource>

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) ASProgressPopUpView *progressView;

@property (assign, nonatomic) CGFloat progress;

@property (strong, nonatomic) UIButton *cancelButton;

@property (copy, nonatomic) void (^cancelUpload)(void);

@end
@implementation TBUploadPromptHUD

- (instancetype)init;
{
    
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];;
        
        UIView *hideView = [[UIView alloc] initWithFrame:self.bounds];
        hideView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addSubview:hideView];
        
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 4;
        [self addSubview:self.contentView];
        
        self.progressView = [[ASProgressPopUpView alloc] init];
        self.progressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:13];
        self.progressView.popUpViewAnimatedColors = @[NAVIGATION_COLOR];
        self.progressView.dataSource = self;
        self.progressView.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.progressView];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setTitle:@"取消上传" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor: NAVIGATION_COLOR forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:15];
        self.cancelButton.layer.cornerRadius = 4;
        self.cancelButton.layer.borderColor = BODER_COLOR.CGColor;
        self.cancelButton.layer.borderWidth = 0.5;
        [self.cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelButton];
        
        TBWeakSelf
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).offset(60);
            make.right.equalTo(weakSelf.mas_right).offset(-60);
            make.height.mas_equalTo(120);
            make.centerY.equalTo(weakSelf.mas_centerY);
        }];
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.height.mas_equalTo(2);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(50);
        }];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-8);
        }];
        
    }
    return self;
}
#pragma mark --- 进度处理----
- (void)progress:(CGFloat)offset
{
    self.progress = self.progress+offset;
    if (self.progress>1)
    {
        self.progress = 1.0f;
    }
    if (offset == 1000)
    {
        self.progress = 0.9;
    }
    [self.progressView setProgress:self.progress animated:YES];
}

- (void)uploadErr;
{
    self.prompStr = @"上传失败了";
    [self.progressView setProgress:self.progress animated:YES];
    [self performSelector:@selector(hideButtonClick) withObject:nil afterDelay:2.0f];
}

- (void)uploadSuccessful:(NSString *)str;
{
    self.progress = 1.0f;
    self.prompStr = str;
    [self.progressView setProgress:self.progress animated:YES];
    [self hideButtonClick];
}
#pragma mark  点击事件啊

- (void)cancelClick
{
    if (self.cancelUpload)
    {
        self.cancelUpload();
    }
    [self hideButtonClick];
}
-(void)hideButtonClick{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.progressView hidePopUpViewAnimated:YES];
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)showViewCancelUpload:(void(^)(void))cancel;
{
    self.alpha = 1;
    self.cancelUpload = cancel;
    [[APPDELEGATE window] addSubview:self];
    self.contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
            [self.progressView showPopUpViewAnimated:YES];
        }];
    }];
    
}
- (void)hideHUD;
{
    [self hideButtonClick];

}
#pragma mark - ASProgressPopUpView dataSource

- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    if (self.prompStr.length == 0)
    {
        NSString *strInfo;
        if (progress < 0.2) {
            strInfo = @"基础数据上传";
        } else if (progress > 0.2 && progress < 0.6) {
            strInfo = @"正在上传图片";
        } else if (progress > 0.75 && progress < 1.0) {
            strInfo = @"稍等";
        } else if (progress >= 1.0) {
            strInfo = @"上传完成";
        }
        return strInfo;
    }
    else
    {
        return self.prompStr;
    }

}

- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return NO;
}

@end
