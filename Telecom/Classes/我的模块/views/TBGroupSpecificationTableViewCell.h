//
//  TBGroupSpecificationTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TBGroupSpecificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indexNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;
@property (weak, nonatomic) IBOutlet UIButton *ritButton;


@property (nonatomic, copy) void(^deleteButton)(void);
@property (nonatomic, copy) void(^cellText)(NSString *text);

@end
