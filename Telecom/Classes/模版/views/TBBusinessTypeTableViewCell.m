//
//  TBBusinessTypeTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const TBBusinessTypeTableViewCellID = @"TBBusinessTypeTableViewCellID";
#import "TBBusinessTypeTableViewCell.h"
#import "TBTaskListMode.h"

@implementation TBBusinessTypeTableViewCell
{
    __weak IBOutlet UIButton *taskButton;
    __weak IBOutlet UIButton *errButton;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *phoneLabel;
    __weak IBOutlet UILabel *typeLabel;
    __weak IBOutlet UILabel *adderssLabel;
    NSInteger type;
    TBTaskListRoot *rootMode;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    taskButton.layer.cornerRadius = 4;
    errButton.layer.cornerRadius =4;
    errButton.layer.masksToBounds = YES;
    errButton.layer.borderColor = BODER_COLOR.CGColor;
    errButton.layer.borderWidth = 0.5;
}
- (void)updateMode:(TBTaskListRoot*)list;
{
    rootMode = list;
    nameLabel.text = list.name;
    typeLabel.text = list.type;
    phoneLabel.text = list.tel;
    adderssLabel.text = list.address;

}
- (IBAction)taskClick:(id)sender
{
    if (self.tableViewCellClick)
    {
        self.tableViewCellClick(0,rootMode);
    }

}
- (IBAction)errClick:(id)sender
{
    if (self.tableViewCellClick)
    {
        self.tableViewCellClick(1,rootMode);
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
