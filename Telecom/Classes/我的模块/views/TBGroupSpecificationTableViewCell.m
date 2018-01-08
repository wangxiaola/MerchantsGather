//
//  TBGroupSpecificationTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBGroupSpecificationTableViewCell.h"

@interface TBGroupSpecificationTableViewCell() <UITextFieldDelegate>

@end

@implementation TBGroupSpecificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.infoTextField.delegate = self;
    // Initialization code
}
- (IBAction)deleteClick:(id)sender
{
    if (self.deleteButton)
    {
        self.deleteButton();
    }
}
#pragma mark ---UITextFieldDelegate--
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
//    if (toBeString.length > 50) {
//        
//        textField.text = [toBeString substringToIndex:50];
//        hudShowError(@"字数不能超过50个");
//        return NO;
//    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.cellText)
    {
        self.cellText(self.infoTextField.text);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
