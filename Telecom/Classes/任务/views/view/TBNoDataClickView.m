//
//  TBNoDataClickView.m
//  Telecom
//
//  Created by 王小腊 on 2018/8/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBNoDataClickView.h"

@implementation TBNoDataClickView

/**
 加载view
 
 @param frame frame
 @return self
 */
+ (TBNoDataClickView *)loadingNibConetenViewWithFrame:(CGRect)frame;
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TBNoDataClickView" owner:nil options:nil];
    TBNoDataClickView *view = [array lastObject];
    view.frame = frame;
    view.promptLabel.textColor = [UIColor grayColor];
    [view.addClickButton setTitleColor:NAVIGATION_COLOR forState:UIControlStateNormal];
    return view;
}

@end
