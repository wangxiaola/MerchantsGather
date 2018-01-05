//
//  ZKPickerViewCell.m
//  CYmiangzhu
//
//  Created by 小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKPickerViewCell.h"

@implementation ZKPickerViewCell

- (instancetype)initWithFrame:(CGRect)frame ;
{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.label.textColor = [UIColor blackColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.center = self.center;
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.font = [UIFont boldSystemFontOfSize:14];
        self.label.numberOfLines = 2;
        [self addSubview:self.label];
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
