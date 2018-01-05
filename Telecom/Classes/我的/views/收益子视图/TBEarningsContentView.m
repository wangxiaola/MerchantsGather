//
//  TBEarningsContentView.m
//  Telecom
//
//  Created by 王小腊 on 2017/8/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBEarningsContentView.h"
#import "ScottCounter.h"
#import "TBEarningsDateSelectionView.h"

@interface TBEarningsContentView()
// 总收益
@property (nonatomic, weak) UILabel *totalRevenueLabel;

@property (nonatomic, weak) UILabel *dateLabel;

@end
@implementation TBEarningsContentView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UIButton class]]) {
        return view;
    }
    return nil;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}
- (void)setup
{
    self.backgroundColor = BACKLIST_COLOR;
    /*  创建收益明细 */
    UIView *bottomView         = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UILabel *earningsLabel  = [[UILabel alloc] init];
    earningsLabel.text      = @"收益明细";
    earningsLabel.textColor = [UIColor blackColor];
    earningsLabel.font      = [UIFont systemFontOfSize:15];
    [bottomView addSubview:earningsLabel];
    
    UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarButton setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [calendarButton addTarget:self action:@selector(calendarClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:calendarButton];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:centerView];
    
    UILabel *transactionLabel = [[UILabel alloc] init];
    transactionLabel.text = @"总收益 (元)";
    transactionLabel.textAlignment = NSTextAlignmentLeft;
    transactionLabel.font = [UIFont systemFontOfSize:16];
    transactionLabel.textColor = [UIColor darkGrayColor];
    [contentView addSubview:transactionLabel];
    
    
    UILabel *totalRevenueLabel = [[UILabel alloc] init];
    totalRevenueLabel.font = [UIFont systemFontOfSize:19 weight:0.3];
    totalRevenueLabel.textColor = NAVIGATION_COLOR;
    totalRevenueLabel.textAlignment = NSTextAlignmentLeft;
    totalRevenueLabel.text = @"-";
    [contentView addSubview:totalRevenueLabel];
    self.totalRevenueLabel = totalRevenueLabel;

    
    CGFloat clearance = 20;
    TBWeakSelf
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(TBTitleHeight);
    }];
    [earningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(clearance);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    [calendarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-clearance);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.right.equalTo(calendarButton.mas_left).offset(-10);
    }];
    /**中间视图布局***/
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_top).offset(1);
        make.bottom.equalTo(bottomView.mas_top).offset(-1);
    }];
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.top.bottom.equalTo(contentView);
        make.width.equalTo(@2);
    }];
    
    [transactionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(clearance);
        make.top.equalTo(contentView.mas_top).offset(clearance);
        make.right.equalTo(centerView.mas_left).offset(-6);
    }];

    [totalRevenueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView.mas_left).offset(clearance);
        make.bottom.equalTo(contentView.mas_bottom).offset(-clearance);
        make.right.equalTo(centerView.mas_left).offset(-6);
    }];


}
#pragma mark  ----更新数字动画----
/**
 更新数据
 
 @param postersNumber 收益
 @param date 时间
 */
- (void)updataPostersNumber:(CGFloat)postersNumber dateString:(NSString *)date;
{
    TBWeakSelf
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [weakSelf exampleLabel:weakSelf.totalRevenueLabel toNumber:postersNumber];
        weakSelf.dateLabel.text = date;
    }];
}
- (void)exampleLabel:(UILabel *)label toNumber:(CGFloat)number
{
    label.animationOptions = ScottCounterAnimationOptionCurveEaseInOut;
    [label scott_fromNumber:0 toNumber:number duration:1.0f format:^NSString *(CGFloat number) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.positiveFormat = @"###,##0.00";
        NSNumber *amountNumber = [NSNumber numberWithFloat:number];
        return [NSString stringWithFormat:@"¥%@",[formatter stringFromNumber:amountNumber]];
    }];
}

#pragma mark  ----点击事件----
- (void)calendarClick
{
    TBEarningsDateSelectionView *view = [[TBEarningsDateSelectionView alloc] init];
    [view show];
    TBWeakSelf
    [view setSelectionDate:^(NSString *date){
        
        if (weakSelf.earningsSelectionDate) {
            weakSelf.earningsSelectionDate(date);
        }
    }];
}
@end
