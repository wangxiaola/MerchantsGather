//
//  TBTemplateInfoTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBTemplateInfoTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lefLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@end
