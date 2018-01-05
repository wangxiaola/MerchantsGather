//
//  TBAddNewMerchantsTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/9.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBAddNewMerchantsTableViewCell.h"
#import "TBAddMerchantsMode.h"

NSString *const reuseIdentifier = @"TBAddMerchantsTableViewCellID";

@interface TBAddNewMerchantsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *unmaeLabel;
@property (weak, nonatomic) IBOutlet UILabel *uphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
@implementation TBAddNewMerchantsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setMode:(TBAddMerchantsMode *)mode
{
    self.nameLabel.text = mode.name.length == 0 ?@"暂无":mode.name;
    self.telLabel.text = mode.tel.length == 0?@"暂无":mode.tel;
    self.addressLabel.text = mode.address.length == 0?@"暂无":mode.address;
    self.unmaeLabel.text = mode.uname.length == 0?@"暂无":mode.uname;
    self.uphoneLabel.text = mode.uphone.length == 0 ?@"暂无":mode.uphone;
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
