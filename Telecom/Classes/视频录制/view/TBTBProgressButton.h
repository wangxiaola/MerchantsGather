//
//  TBTBProgressButton.h
//  Telecom
//
//  Created by 王小腊 on 2018/2/6.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBTBProgressButton : UIView

@property (nonatomic, strong) UIButton *button;

- (instancetype)initWithFrame:(CGRect)frame addTarget:(id)target buttonAction:(SEL)action;
@end
