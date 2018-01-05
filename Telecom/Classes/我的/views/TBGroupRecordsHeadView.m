//
//  TBGroupRecordsHeadView.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/13.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBGroupRecordsHeadView.h"
#import "TBDiscountCouponMode.h"

@implementation TBGroupRecordsHeadView
{
    __weak IBOutlet UIImageView *headImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *infoLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *soldLabel;
    __weak IBOutlet UILabel *numLabel;
}
- (void)setList:(TBDiscountCouponMode *)list
{
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 4;
    [ZKUtil downloadImage:headImageView imageUrl:list.logo duImageName:@"homeDefault"];
    nameLabel.text = list.shopname;
    infoLabel.text = list.name;
    timeLabel.text = [NSString stringWithFormat:@"有效期至：%@",list.edate];
    NSString *total = [NSString stringWithFormat:@"已售%@份",list.total];
    NSString *totalnumber = [NSString stringWithFormat:@"共%@份",list.totalnumber];
    soldLabel.attributedText = [ZKUtil ls_changeFontAndColor:[UIFont systemFontOfSize:16] Color:RGB(23, 189, 144) TotalString:total SubStringArray:@[list.total]];
    numLabel.attributedText = [ZKUtil ls_changeFontAndColor:[UIFont systemFontOfSize:16] Color:RGB(213, 51, 23) TotalString:totalnumber SubStringArray:@[list.totalnumber]];
    
}

@end
