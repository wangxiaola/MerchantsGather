//
//  TBEarningsTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const TBEarningsTableViewCellID = @"TBEarningsTableViewCellID";
#import "TBEarningsTableViewCell.h"
#import "TBEarningsESRootClass.h"
@interface TBEarningsTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradingLabel;
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
@implementation TBEarningsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)updataCellData:(TBEarningsDetails *)list;
{
    [ZKUtil downloadImage:self.photoImageView imageUrl:list.headimg duImageName:@"homeDefault"];
    self.nameLabel.text = list.shopname;
    self.tradingLabel.text = [NSString stringWithFormat:@"￥%.2f",list.paymoney];
    self.earningsLabel.text = [NSString stringWithFormat:@"￥%.2f",list.money];
    if ([list.paytime isKindOfClass:[NSString class]])
    {
        NSArray *data = [list.paytime componentsSeparatedByString:@" "];
        self.dateLabel.text = data.firstObject;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
