//
//  TBTaskMakeFootView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBTaskMakeFootView.h"
#import "TBMoreReminderView.h"

@implementation TBTaskMakeFootView
{
    
    UIButton *_lefButton;
    UIButton *_centerButton;
    UIButton *_ritButton;
    
}
- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
        self.maxPage = 6;
        _lefButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lefButton .titleLabel.font = [UIFont systemFontOfSize:16 weight:0.2];
        [_lefButton addTarget:self action:@selector(lefClick) forControlEvents:UIControlEventTouchUpInside];
        [_lefButton setBackgroundColor:[UIColor whiteColor]];
        [_lefButton setTitleColor:NAVIGATION_COLOR forState:UIControlStateNormal];
        [self addSubview:_lefButton];
        
        _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerButton .titleLabel.font = [UIFont systemFontOfSize:16 weight:0.2];
        [_centerButton addTarget:self action:@selector(centerClick) forControlEvents:UIControlEventTouchUpInside];
        [_centerButton setTitle:@"保存任务" forState:UIControlStateNormal];
        [_centerButton setBackgroundColor:[UIColor orangeColor]];
        [_centerButton setTitleColor:[UIColor whiteColor ] forState:UIControlStateNormal];
        [self addSubview:_centerButton];
        
        _ritButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ritButton .titleLabel.font = [UIFont systemFontOfSize:16 weight:0.2];
        [_ritButton addTarget:self action:@selector(ritClick) forControlEvents:UIControlEventTouchUpInside];
        [_ritButton setBackgroundColor:NAVIGATION_COLOR];
        [_ritButton setTitleColor:[UIColor whiteColor ] forState:UIControlStateNormal];
        [self addSubview:_ritButton];
        
        TBWeakSelf
        [_lefButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.equalTo(weakSelf);
            make.width.equalTo(_ritButton.mas_width);
        }];
        [_centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(weakSelf);
            make.left.equalTo(_lefButton.mas_right);
            make.right.equalTo(_ritButton.mas_left);
            make.width.equalTo(@0);
        }];
        [_ritButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(weakSelf);
            make.width.equalTo(_lefButton.mas_width);
            
        }];
    }
    
    return self;
    
}
#pragma mark --- click ---
- (void)lefClick
{
    if ([self.delegate respondsToSelector:@selector(footViewTouchUpInsideType:)]) {
        
        [self.delegate footViewTouchUpInsideType:YES];
    }
}
- (void)centerClick
{
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否保存任务到本地？"];
    [more showHandler:^{
        if ([self.delegate respondsToSelector:@selector(footViewTouchUpInsideSave)]) {
            
            [self.delegate footViewTouchUpInsideSave];
        }
    }];

}
- (void)ritClick
{
    if ([self.delegate respondsToSelector:@selector(footViewTouchUpInsideType:)]) {
        
        [self.delegate footViewTouchUpInsideType:NO];
    }
}
#pragma mark --- 逻辑处理 ----
- (void)updateFootViewStyle:(NSInteger)index
{
    NSString *lefTextString = @"";
    NSString *ritTextString = @"";
    CGFloat buttonWidth = index == self.maxPage ?_SCREEN_WIDTH/3:0.0f;
    if (index == 0)
    {
        _lefButton.enabled = NO;
        _lefButton.alpha = 0.4f;
        lefTextString = @"上一步";
        ritTextString = @"下一步";
        
    }
    else if (index == self.maxPage)
    {
        _lefButton.enabled = YES;
        _lefButton.alpha = 1.0f;
        lefTextString = @"上一步";
        ritTextString = @"上传发布";
        
    }
    else
    {
        _lefButton.enabled = YES;
        _lefButton.alpha = 1.0f;
        lefTextString = @"上一步";
        ritTextString = @"下一步";
    }
    [UIView animateWithDuration:0.2 animations:^{
        [_centerButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(buttonWidth);
        }];
        [_lefButton layoutIfNeeded];
        [_ritButton layoutIfNeeded];
        [_centerButton layoutIfNeeded];
        
    }];
    
    [_lefButton setTitle:lefTextString forState:UIControlStateNormal];
    [_ritButton setTitle:ritTextString forState:UIControlStateNormal];
    
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
