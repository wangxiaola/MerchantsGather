//
//  TBNoteTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/8.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQTextView.h"

@interface TBNoteTableViewCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet IQTextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *promptButton;

@property (assign, nonatomic) BOOL isLimitedNumber;
@end
