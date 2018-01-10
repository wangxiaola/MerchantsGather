//
//  TBVideoRecordingView.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/10.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBVideoRecordingView.h"

@implementation TBVideoRecordingView

- (instancetype)init
{
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        [self createViews];
    }
    return self;
}
#pragma mark  ----视图创建----
- (void)createViews
{
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    
}
#pragma mark  ----show----
/**
 弹出录音视图
 
 @param time 时间
 */
- (void)showRecordingTime:(double)time;
{
    [[APPDELEGATE window] addSubview:self];
}
@end
