//
//  TBEarningsHeaderFooterView.m
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const TBEarningsHeaderViewID = @"TBEarningsHeaderViewID";

#import "TBEarningsHeaderView.h"
#import "TBEarningsESRootClass.h"

@interface TBEarningsHeaderView()

@property (nonatomic, weak) UILabel *dateLabel;

@property (nonatomic, weak) UILabel *tradingLabel;

@property (nonatomic, weak) UILabel *earningsLabel;

@end
@implementation TBEarningsHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = BACKLIST_COLOR;
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.text = @"----年--月";
        dateLabel.font = [UIFont systemFontOfSize:14];
        dateLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
        UILabel *tradingLabel = [[UILabel alloc] init];
        tradingLabel.text = @"交易 ￥0.00";
        tradingLabel.font = [UIFont systemFontOfSize:14];
        tradingLabel.textColor = [UIColor grayColor];
        tradingLabel.hidden = YES;
        [self.contentView addSubview:tradingLabel];
        self.tradingLabel = tradingLabel;
        
        UILabel *earningsLabel = [[UILabel alloc] init];
        earningsLabel.text = @"收益￥0.00";
        earningsLabel.font = [UIFont systemFontOfSize:14];
        earningsLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:earningsLabel];
        self.earningsLabel = earningsLabel;
        
        TBWeakSelf
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        [tradingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dateLabel.mas_right).offset(20);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        [earningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        
    }
    return self;
}
- (void)updataHeaderViewData:(TBEarningsRoot *)root;
{
    self.dateLabel.text = root.month;
    self.tradingLabel.text = [NSString stringWithFormat:@"交易￥%.2f",root.monthpay];
    self.earningsLabel.text = [NSString stringWithFormat:@"收益￥%.2f",root.monthmoney];
}

@end
