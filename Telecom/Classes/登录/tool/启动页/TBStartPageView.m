//
//  TBStartPageView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/31.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBStartPageView.h"
#import "TBTimeButton.h"
@implementation TBStartPageView

- (instancetype)init
{
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self)
    {
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
        backImageView.frame = CGRectMake(0, 0, _SCREEN_WIDTH, _SCREEN_HEIGHT);
        backImageView.userInteractionEnabled = YES;
        [self addSubview:backImageView];
        
        UIButton *bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _SCREEN_HEIGHT-100, _SCREEN_WIDTH, 100)];
        [bottomButton addTarget:self action:@selector(bottomClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomButton];
        
        TBTimeButton *drawCircleView = [[TBTimeButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 55, 30, 40, 40)];
        drawCircleView.lineWidth = 2;
        [drawCircleView setTitle:@"跳过" forState:UIControlStateNormal];
        [drawCircleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        drawCircleView.titleLabel.font = [UIFont systemFontOfSize:14];
        drawCircleView.animationDuration = 5;
        drawCircleView.trackColor = [UIColor whiteColor];
        drawCircleView.fillColor = [UIColor clearColor];
        drawCircleView.progressColor = NAVIGATION_COLOR;
        [drawCircleView addTarget:self action:@selector(removeProgress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:drawCircleView];
        /**
         *  progress 完成时候的回调
         */
        TBWeakSelf
        [drawCircleView startAnimationDuration:5 withBlock:^{
            [weakSelf removeProgress];
        }];

    }
    
    return self;

}
- (void)show;
{
   [[APPDELEGATE window] addSubview:self];
}
- (void)bottomClick
{
    [self removeProgress];
}
- (void)removeProgress
{
    [ZKUtil saveBoolForKey:START_PAGE valueBool:YES];
    self.transform = CGAffineTransformMakeScale(1, 1);
    self.alpha = 1;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.05;
        self.transform = CGAffineTransformMakeScale(5, 5);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

@end
