//
//  TBTBProgressButton.m
//  Telecom
//
//  Created by 王小腊 on 2018/2/6.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBTBProgressButton.h"

@implementation TBTBProgressButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithFrame:(CGRect)frame addTarget:(id)target buttonAction:(SEL)action;
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        UIButton *bty = [UIButton buttonWithType:UIButtonTypeCustom];
        bty.backgroundColor = [UIColor clearColor];
        [bty addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bty];
        self.button = bty;
        
        [bty mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
    }
    return self;
}

@end
