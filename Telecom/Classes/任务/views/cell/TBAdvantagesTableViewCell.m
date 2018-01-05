//
//  TBAdvantagesTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/14.
//  Copyright © 2016年 王小腊. All rights reserved.
//

NSString *const TBAdvantagesTableViewCellID = @"TBAdvantagesTableViewCellID";
#import "TBAdvantagesTableViewCell.h"

@interface TBAdvantagesTableViewCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordingButton;

@end
@implementation TBAdvantagesTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.borderColor = BODER_COLOR.CGColor;
    self.textView.layer.borderWidth = 0.8;
    self.textView.layer.cornerRadius = 4;
    self.textView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);//设置页边距
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeySend;
    
    self.recordingButton.hidden = HIDE_RECORDING;
}

#pragma mark --UITextView--

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
   return YES;
    
}
- (void)textViewDidChange:(UITextView *)textView
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

- (IBAction)buttonClick:(id)sender
{
    if (self.startRecording)
    {
        self.startRecording(self);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
