//
//  TBMapPromptBoxView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/6.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBMapPromptBoxView.h"

@implementation TBMapPromptBoxView
{
    UIView *contentView;
    CGFloat contentWidth;
    CGFloat contentHeight;
}

- (instancetype)initMarkedWords:(NSString*)words;
{
    
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        contentWidth = _SCREEN_WIDTH *0.82;
        contentHeight = 180;
        
        UIButton *hideButton = [[UIButton alloc] initWithFrame:self.bounds];
        hideButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:hideButton];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)];
        contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 5;
        [self addSubview:contentView];
        
        UILabel *reminderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, contentWidth, 50)];
        reminderLabel.backgroundColor =[UIColor clearColor];
        reminderLabel.text = @"温馨提示";
        reminderLabel.textAlignment = NSTextAlignmentCenter;
        reminderLabel.textColor = NAVIGATION_COLOR;
        reminderLabel.font = [UIFont systemFontOfSize:18];
        reminderLabel.font = [UIFont boldSystemFontOfSize:18];
        [contentView addSubview:reminderLabel];
        
        UIView *inview =[[UIView alloc]initWithFrame:CGRectMake(3, 49, contentView.frame.size.width -6, 1)];
        inview.backgroundColor = NAVIGATION_COLOR;
        [contentView addSubview:inview];
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, 60,contentView.frame.size.width -20, 55)];
        label.text = words;
        label.numberOfLines = 2;
        label.textColor =[UIColor grayColor];
        label.font =[UIFont systemFontOfSize:18 weight:0.1];
        [contentView addSubview:label];
        
        UIButton *confirmButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 130, contentWidth, contentHeight-130)];
        confirmButton .backgroundColor =[UIColor orangeColor];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font =[UIFont systemFontOfSize:18];
        [confirmButton addTarget:self action:@selector(hideButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:confirmButton];

        
    }
    return self;
}
- (void)hideButtonClick{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
- (void)disappear;
{
   [self removeFromSuperview];
}
- (void)show;
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
