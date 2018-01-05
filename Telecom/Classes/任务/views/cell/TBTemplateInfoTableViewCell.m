//
//  TBTemplateInfoTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTemplateInfoTableViewCell.h"

@implementation TBTemplateInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textField.delegate = self;
}

#pragma mark  --- UITextFieldDelegate ---
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self endEditing:YES];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
