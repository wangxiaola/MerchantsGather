//
//  TBPovertyAlleviationTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/5/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBPovertyAlleviationTableViewCell.h"
NSString *const TBPovertyAlleviationTableViewCellID = @"TBPovertyAlleviationTableViewCellID";

@interface TBPovertyAlleviationTableViewCell()<UITextFieldDelegate>


@end
@implementation TBPovertyAlleviationTableViewCell
{

    UILabel *_nameLabel;
    UITextField *_textField;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.textColor = [UIColor grayColor];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
        [self.contentView addSubview:_textField];

        TBWeakSelf

        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(weakSelf.mas_left).offset(8);
            make.top.bottom.equalTo(weakSelf);
        }];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.right.equalTo(weakSelf.mas_right).offset(-8);
            make.width.equalTo(@100);
            make.top.bottom.equalTo(weakSelf);
        }];
    }
    return self;
}
#pragma mark --UITextFieldDelegate--
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSString *name = textField.text;
    if (self.textFieldName)
    {
        self.textFieldName(name);
    }
}
- (void)textFieldEditEnd:(TextFieldName)name;
{
    self.textFieldName = name;
}
- (void)textLefName:(NSString *)lefName rightName:(NSString *)rightName;
{
    if (lefName&&rightName)
    {
        _nameLabel.text = lefName;
        _textField.placeholder = rightName;
        _textField.userInteractionEnabled = rightName.length != 0;
    }
}
- (void)assignmentTextFieldText:(NSString *)name;
{
    NSString *nameString = [NSString stringWithFormat:@"%@",name];
    if (![nameString isEqualToString:@"(null)"])
    {
        if (nameString.integerValue == 0)
        {
           _textField.text  = @"";
        }
        else
        {
           _textField.text = nameString;
        }
    }
}
- (void)textFiledIsEditor:(BOOL)editor;
{
    _textField.userInteractionEnabled = editor;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
