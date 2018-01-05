//
//  TBBankListCellView.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBBankListCellView.h"

@implementation TBBankListCellView

/**
 创建cell
 
 @param boardType 键盘类型
 @param placeholder 默认提示
 @param leftText 左边提示
 @return view
 */
- (instancetype)initTextFieldType:(UIKeyboardType)boardType fieldPlaceholder:(NSString *)placeholder cellLeftText:(NSString *)leftText;
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.text = leftText;
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.textColor = [UIColor blackColor];
        [self addSubview:leftLabel];
        
        UITextField *field = [[UITextField alloc] init];
        field.keyboardType = boardType;
        field.textAlignment = NSTextAlignmentRight;
        field.returnKeyType = UIReturnKeyDone;
        field.backgroundColor = [UIColor whiteColor];
        field.placeholder = placeholder;
        field.textColor = [UIColor blackColor];
        field.font = [UIFont systemFontOfSize:14];
        field.delegate = self;
        [self addSubview:field];
        self.textField = field;
        
        TBWeakSelf
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).offset(20);
            make.top.bottom.equalTo(weakSelf);
            make.width.mas_equalTo(_SCREEN_WIDTH/3);
        }];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.mas_right).offset(-10);
            make.top.bottom.equalTo(weakSelf);
            make.left.equalTo(leftLabel.mas_right).offset(10);
        }];
    }
    return self;
}
/**
 添加覆盖view
 */
- (void)addClickCoveringView;
{
    UIButton *coveringButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coveringButton setBackgroundColor:[UIColor clearColor]];
    [coveringButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:coveringButton];
    TBWeakSelf
    [coveringButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.top.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.mas_left).offset(_SCREEN_WIDTH/3);
    }];
    self.textField.enabled = NO;
}
- (void)clickButton
{
    if ([self.delegate respondsToSelector:@selector(coveringViewClick)]) {
        [self.delegate coveringViewClick];
    }
}
#pragma mark  ----UITextFieldDelegate----
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if ([self.delegate respondsToSelector:@selector(textFieldEditEnd)]) {
        [self.delegate textFieldEditEnd];
    }
}
@end
