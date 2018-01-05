//
//  TBGroupManagementTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/11.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBGroupManagementTableViewCell.h"
#import "TBDiscountCouponMode.h"

@implementation TBGroupManagementTableViewCell
{
    __weak IBOutlet UIImageView *contentImageView;
    __weak IBOutlet UIImageView *tagImageView;
    __weak IBOutlet UILabel *stateLabel;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *priceLabel;
    __weak IBOutlet UILabel *endShowLabel;
    __weak IBOutlet UIButton *centerButton;
    __weak IBOutlet UIButton *ritButton;
    __weak IBOutlet NSLayoutConstraint *tagViewWidth;
    NSInteger _state;
    struct{
        unsigned int checkTheDetailsData   :1;
        unsigned int sharingData           :1;
        unsigned int editData              :1;
        unsigned int deleteData            :1;
        unsigned int purchaseData          :1;
    }_delegateFlags;
    TBDiscountCouponMode *_couponList;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *taskImage = [UIImage imageNamed:@"tg_icon"];
    [taskImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0.5, 0.5, 0)];
    [tagImageView setImage:taskImage];
    contentImageView.layer.masksToBounds = YES;
    contentImageView.clipsToBounds = YES;
    contentImageView.layer.cornerRadius = 4;
    endShowLabel.layer.masksToBounds = YES;
    endShowLabel.layer.cornerRadius = 4;
    nameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    endShowLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
}
- (void)setDelegate:(id<TBGroupManagementTableViewCellDelegate>)delegate
{
    _delegate = delegate;
   
    _delegateFlags.checkTheDetailsData = [delegate respondsToSelector:@selector(checkTheDetailsData:)];
    _delegateFlags.sharingData = [delegate respondsToSelector:@selector(sharingActivitiesData:)];
    _delegateFlags.editData = [delegate respondsToSelector:@selector(editData:)];
    _delegateFlags.deleteData = [delegate respondsToSelector:@selector(deleteActivitiesData:)];
    _delegateFlags.purchaseData = [delegate respondsToSelector:@selector(purchaseRecordsData:)];
}

- (void)updateMode:(TBDiscountCouponMode*)couponList share:(BOOL)share;
{
    _couponList = couponList;
    _state = couponList.state.integerValue;
    if (couponList.priceWidth == 0)
    {
        CGFloat priceW = [ZKUtil contentLabelSize:CGSizeMake(200, 30) labelFont:priceLabel.font labelText:couponList.price].width+40;
        couponList.priceWidth = priceW;
    }
   
    tagViewWidth.constant = couponList.priceWidth;
    /*1-进行中,2-未开始3-结束*/
    priceLabel.text = couponList.price;
    nameLabel.text = [NSString stringWithFormat:@"  %@  ",couponList.name];
    [ZKUtil downloadImage:contentImageView imageUrl:couponList.logo duImageName:@"productDefault"];
    switch (couponList.state.integerValue) {
        case 1:
            stateLabel.text = @"进行中";
            [centerButton setTitle:@"购买记录" forState:UIControlStateNormal];
            [ritButton setTitle:@"点击分享" forState:UIControlStateNormal];
            endShowLabel.hidden = YES;
            ritButton.enabled = share;
            ritButton.alpha = share?1.0f:0.3f;
            break;
        case 2:
            stateLabel.text = @"未开始";
            [centerButton setTitle:@"编辑修改" forState:UIControlStateNormal];
            [ritButton setTitle:@"删除活动" forState:UIControlStateNormal];
            endShowLabel.hidden = YES;
            ritButton.enabled = YES;
            ritButton.alpha = 1.0f;
            break;
        case 3:
            stateLabel.text = @"已结束";
            [centerButton setTitle:@"购买记录" forState:UIControlStateNormal];
            [ritButton setTitle:@"删除活动" forState:UIControlStateNormal];
            endShowLabel.hidden = YES;
            ritButton.enabled = YES;
            ritButton.alpha = 1.0f;
            break;
            
        default:
            break;
    }
    
}
- (IBAction)lefButtonClick:(id)sender
{
    if (_delegateFlags.checkTheDetailsData)
    {
        [self.delegate checkTheDetailsData:_couponList];
    }
    
}
- (IBAction)centerButtonClick:(id)sender
{
    if (_state == 2)
    {
        if (_delegateFlags.editData)
        {
            [self.delegate editData:_couponList];
        }
    }
    else
    {
        if (_delegateFlags.purchaseData)
        {
            [self.delegate purchaseRecordsData:_couponList];
        }
    }
}
- (IBAction)ritButtonClick:(id)sender
{
    
    
    if (_state == 1) {
        
        if (_delegateFlags.sharingData)
        {
            [self.delegate sharingActivitiesData:_couponList];
        }
    }
    else
    {
        if (_delegateFlags.deleteData)
        {
            [self.delegate deleteActivitiesData:_couponList];
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
