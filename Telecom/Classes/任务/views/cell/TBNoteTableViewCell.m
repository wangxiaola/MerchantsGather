//
//  TBNoteTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/8.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBNoteTableViewCell.h"

@implementation TBNoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);//设置页边距
    self.textView.delegate = self;
    self.isLimitedNumber = YES;
}

#pragma mark --UITextView--
- (void)textViewDidChange:(UITextView *)textView
{
    if (self.isLimitedNumber == YES)
    {
        NSString *toBeString = textView.text;
        NSString *lang = textView.textInputMode.primaryLanguage;
        if ([lang isEqualToString:@"zh-Hans"])
        {
            UITextRange *selectedRange = [textView markedTextRange];
            if (!selectedRange && toBeString.length>25)
            {
                hudShowError(@"不能超过25个字");
                textView.text = [toBeString substringToIndex:25];
            }
        }
        else if (toBeString.length > 25)
        {
            hudShowError(@"不能超过25个字");
            textView.text = [toBeString substringToIndex:25];
        }
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
