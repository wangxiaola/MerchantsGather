//
//  MyTaskCell.m
//  Telecom
//
//  Created by zhangxingdong 张兴栋 on 16/12/7.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "MyTaskCell.h"


@interface MyTaskCell ()

@property (weak, nonatomic) IBOutlet UIButton *makingLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation MyTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
     self.makingLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
     self.makingLabel.layer.borderWidth = 0.3;
     self.makingLabel.layer.cornerRadius = 4;
     self.makingLabel.layer.masksToBounds = YES;
     self.makingLabel.clipsToBounds = YES;
     self.accessoryType = UITableViewCellAccessoryNone;
     self.selectionStyle = UITableViewCellEditingStyleNone;
    
    // 设置 左边竖线
    self.lineView.clipsToBounds = YES;
    self.lineView.layer.masksToBounds = YES;
    self.lineView.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
