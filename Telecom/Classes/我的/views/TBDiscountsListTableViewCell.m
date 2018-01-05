//
//  TBDiscountsListTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBDiscountsListTableViewCell.h"

@implementation TBDiscountsListTableViewCell
{
    __weak IBOutlet NSLayoutConstraint *imageHeight;
    __weak IBOutlet NSLayoutConstraint *imageWidth;
    __weak IBOutlet NSLayoutConstraint *centerButtonWidth;
    __weak IBOutlet UIImageView *backImageView;
    __weak IBOutlet UILabel *linesLabel;
    __weak IBOutlet UILabel *stateLabel;
    __weak IBOutlet UILabel *codeLabel;
    __weak IBOutlet UILabel *instructionsLabel;
    __weak IBOutlet UILabel *rulesLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UIButton *centerButton;
    __weak IBOutlet UIButton *rightButton;
    CGFloat _centerWidht;
    NSInteger _state;
    TBDiscountsMode *_list;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    instructionsLabel.text = @"仅用于线下到店支付";
    linesLabel.font = [UIFont systemFontOfSize:30 weight:0.2];
    stateLabel.font = [UIFont systemFontOfSize:18];
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-20 * (CGFloat)M_PI / 180), 1, 0, 0);
    stateLabel.transform = matrix;
    _centerWidht = (_SCREEN_WIDTH - 18)/3;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.userInteractionEnabled = YES;

}
- (void)updataDiscountsCellInfo:(TBDiscountsMode *)data backImageHeight:(CGFloat)height cellType:(BOOL)type;
{
    _list = data;
    //1-进行中 2-未开始 3-结束
    NSString *stateString  = @"";
    NSString *centerString = @"";
    NSString *rightString  = @"";
    CGFloat  center_Widht    = 0.0f;
    _state = data.state.integerValue;
    switch (_state)
    {
        case 1:
            stateString  = @"进行中";
            centerString = @"";
            rightString  = @"领取记录";
            center_Widht    = 0.0f;
            break;
        case 2:
            stateString  = @"未开始";
            centerString = @"编辑修改";
            rightString  = @"删除";
            center_Widht    = _centerWidht;
            break;
        case 3:
            stateString  = @"已结束";
            centerString = @"领取记录";
            rightString  = @"删除";
            center_Widht    = _centerWidht;
            break;
            
        default:
            break;
    }
    
    
    stateLabel.text = stateString;
    [centerButton setTitle:centerString forState:UIControlStateNormal];
    centerButtonWidth.constant = center_Widht;
    [rightButton setTitle:rightString forState:UIControlStateNormal];
    
    NSString *linesString = @"";
    NSString *backImageString = @"";
    if (type == YES)//打折
    {
        linesString = [NSString stringWithFormat:@"%@折",data.money1.integerValue == 0?data.money:data.money1];
        
        backImageString = _state == 3?@"Discounts_g_k":@"Discounts_y";
    }
    else
    {
        linesString = [NSString stringWithFormat:@"¥%@",data.money1.integerValue == 0?data.money:data.money1];
        backImageString = _state == 3?@"Discounts_g_q":@"Discounts_r";
        
    }
    if (data.con.integerValue == 0||data.con.integerValue == 99999)
    {
        rulesLabel.text = @"不限定金额可使用";
    }
    else
    {
        rulesLabel.text = [NSString stringWithFormat:@"单笔订单满%@元可使用",data.con];
    }
    [backImageView setImage:[UIImage imageNamed:backImageString]];
    linesLabel.attributedText = [ZKUtil ls_changeFontAndColor:[UIFont systemFontOfSize:18] Color:[UIColor whiteColor] TotalString:linesString SubStringArray:type == YES?@[@"折"]:@[@"¥"]];;
    codeLabel.text = [NSString stringWithFormat:@"编号 %@",data.code];
    timeLabel.text = [NSString stringWithFormat:@"有效期 %@-%@",[data.sdate stringByReplacingOccurrencesOfString:@"-" withString:@"."],[data.edate stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
    imageHeight.constant = height;
    imageWidth.constant = _SCREEN_WIDTH - 18;
}

- (IBAction)leftButtonClick:(id)sender
{
    
    if (_delegateFlags.checkTheDetailsData)
    {
        [self.deleaget checkTheDetailsData:_list];
    }
    
}
- (IBAction)centerbuttonClick:(id)sender
{
    
    if (_state == 1)
    {
        
    }
    else if (_state == 2)
    {
        if (_delegateFlags.editData)
        {
            [self.deleaget editData:_list];
        }
        
    }
    else if (_state == 3)
    {
        if (_delegateFlags.getTheRecordData) {
            [self.deleaget getTheRecordData:_list];
        }
    }
    
}
- (IBAction)rightbuttonClick:(id)sender
{
    
    if (_state == 1)
    {
        if (_delegateFlags.getTheRecordData) {
            [self.deleaget getTheRecordData:_list];
        }
    }
    else
    {
        if (_delegateFlags.deleteData)
        {
            [self.deleaget deleteData:_list];
        }
    }
    
    
}


- (void)setDeleaget:(id<TBDiscountsTableViewCellDelegate>)deleaget
{
    _deleaget = deleaget;
    
    _delegateFlags.checkTheDetailsData = [deleaget respondsToSelector:@selector(checkTheDetailsData:)];
    _delegateFlags.getTheRecordData = [deleaget respondsToSelector:@selector(getTheRecordData:)];
    _delegateFlags.editData = [deleaget respondsToSelector:@selector(editData:) ];
    _delegateFlags.deleteData = [deleaget respondsToSelector:@selector(deleteData:)];
}

- (void)setFrame:(CGRect)frame
{
    //修改cell的左右边距为10;
    
    static CGFloat margin = 8;
    frame.origin.x = margin;
    frame.size.width -= 2 * frame.origin.x;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
