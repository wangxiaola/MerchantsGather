//
//  TBPovertyAlleviationTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/5/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//


#import <UIKit/UIKit.h>

extern NSString *const TBPovertyAlleviationTableViewCellID;

typedef void(^TextFieldName)(NSString *name);

@interface TBPovertyAlleviationTableViewCell : UITableViewCell

@property (nonatomic, copy) TextFieldName textFieldName;

- (void)textFieldEditEnd:(TextFieldName)name;
- (void)textLefName:(NSString *)lefName rightName:(NSString *)rightName;
- (void)assignmentTextFieldText:(NSString *)name;
- (void)textFiledIsEditor:(BOOL)editor;//  是否可以编辑

@end
