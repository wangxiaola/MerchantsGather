//
//  TBVouchersRecordTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBVouchersRecordTableViewCell.h"
#import "TBVouchersRecordMode.h"
#import "TBGroupRecordsMode.h"

@interface TBVouchersRecordTableViewCell ()
{

    __weak IBOutlet UIImageView *topImageView;
    __weak IBOutlet UIImageView *markImageView;
    __weak IBOutlet NSLayoutConstraint *markViewWidth;
    __weak IBOutlet NSLayoutConstraint *markViewHeight;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *phoneLabel;
    __weak IBOutlet UILabel *timeLabel;
    
}
@end
@implementation TBVouchersRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)updataCellData:(id )list showTopView:(BOOL)show;
{
    if ([list isKindOfClass:[TBVouchersRecordMode class]])
    {
        TBVouchersRecordMode *mode = list;
        nameLabel.text = [NSString stringWithFormat:@"姓名: %@",mode.name];
        phoneLabel.text = [NSString stringWithFormat:@"电话: %@",mode.phone];
        timeLabel.text = [NSString stringWithFormat:@"领取时间: %@",mode.time];
    }
    else if ([list isKindOfClass:[TBGroupRecordsMode class]])
    {
        TBGroupRecordsMode *mode = list;
        nameLabel.text = [NSString stringWithFormat:@"预定时间: %@",mode.phone];
        phoneLabel.text = [NSString stringWithFormat:@"支付时间: %@",mode.time];
        timeLabel.text = [NSString stringWithFormat:@"购买数量: %@份",mode.num];
    }

    topImageView.hidden = show;
     [self changeTheColor:show];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)changeTheColor:(BOOL)selected
{
    if (selected == YES)
    {
        [markImageView setImage:[UIImage imageNamed:@"record_cir"]];
        markViewWidth.constant = 20;
        markViewHeight.constant = 20;
        nameLabel.textColor = phoneLabel.textColor = timeLabel.textColor = RGB(23, 181, 146);
    }
    else
    {
        [markImageView setImage:[UIImage imageNamed:@"record_nomr"]];
        markViewWidth.constant = 10;
        markViewHeight.constant = 10;
        nameLabel.textColor = phoneLabel.textColor = timeLabel.textColor = [UIColor grayColor];
    }
}
@end
