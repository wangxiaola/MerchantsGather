//
//  TBRoomListTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/11/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBRoomListTableViewCell.h"

NSString *const TBRoomListTableViewCellID = @"TBRoomListTableViewCellID";

@implementation TBRoomListTableViewCell
{
    __weak IBOutlet UILabel *roomTypeLabel;
    __weak IBOutlet UILabel *roomPriceLabel;
    __weak IBOutlet UILabel *roomNumberLabel;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
/**
 更新cell值
 
 @param data 数据
 */
- (void)updataCellTextData:(NSDictionary *)data;
{
    roomTypeLabel.text = [data valueForKey:@"type"];
    roomPriceLabel.text = [data valueForKey:@"price"];
    roomNumberLabel.text = [data valueForKey:@"number"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
