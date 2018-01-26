//
//  TBVideoRecordButtonView.h
//  Telecom
//
//  Created by 王小腊 on 2018/1/25.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBVideoRecordButtonView : UIView

@property(assign, nonatomic) CGFloat startValue;
@property(assign, nonatomic) CGFloat lineWidth;
@property(assign, nonatomic) CGFloat value;
@property(strong, nonatomic) UIColor *lineColr;

@property (nonatomic, copy) void (^startRecord)();
- (void)updateLabelText:(CGFloat)text;
@end
