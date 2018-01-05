//
//  TBCityChooseView.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/12.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBCityChooseView.h"
//#import "ChooseLocationView.h"
#define contentHeight 360

@implementation TBCityChooseView
{
    UIView *contentView;
}

//- (ChooseLocationView *)chooseLocationView{
//    
//    if (!_chooseLocationView) {
//        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, contentHeight)];
//        
//    }
//    return _chooseLocationView;
//}

- (instancetype)init;
{
    
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];;
        
        UIButton *hideButton = [[UIButton alloc] initWithFrame:self.bounds];
        hideButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [hideButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hideButton];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, contentHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        
//         [contentView addSubview:self.chooseLocationView];
//
//        TBWeakSelf
//        [self.chooseLocationView setChooseFinish:^{
//            
//            if (weakSelf.addressChooseLocation&&weakSelf.chooseLocationView.address.length>0)
//            {
//                weakSelf.addressChooseLocation(weakSelf.chooseLocationView.address,weakSelf.chooseLocationView.areaCode);
//            }
//            [weakSelf backClick];
//        }];
        
    }
    
    return self;
}


#pragma mark  点击事件啊

- (void)backClick
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        contentView.frame = CGRectMake(0, _SCREEN_HEIGHT+contentHeight,_SCREEN_WIDTH, contentHeight);
    } completion:^(BOOL finished) {
        self.addressChooseLocation = nil;
        [self removeFromSuperview];
    }];
    
}

- (void)showCity:(NSString*)code;
{
    self.alpha = 1;

    [[APPDELEGATE window] addSubview:self];
    
//    if (code.length > 0)
//    {
//        self.chooseLocationView.areaCode = code;
//    }
    contentView.frame = CGRectMake(0, _SCREEN_HEIGHT+contentHeight,_SCREEN_WIDTH, contentHeight);
    [UIView animateWithDuration:0.3 animations:^{
        
        contentView.frame = CGRectMake(0, _SCREEN_HEIGHT-contentHeight,_SCREEN_WIDTH, contentHeight);
    }];
    
}
@end
