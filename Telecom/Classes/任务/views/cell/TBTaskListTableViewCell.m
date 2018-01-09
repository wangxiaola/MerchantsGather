//
//  TBTaskListTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.
//

NSString *const TBTaskListTableViewCellID = @"TBTaskListTableViewCellID";
#import "TBTaskListTableViewCell.h"
#import "TBTaskListMode.h"

@interface TBTaskListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *adderssLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailsWidth;
@property (weak, nonatomic) IBOutlet UIImageView *labeBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activationWidth;


@property (nonatomic, strong) TBTaskListRoot *mode;

@property (nonatomic) Tasktype cellTasktype;
@end

@implementation TBTaskListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *taskImage = [UIImage imageNamed:@"tast_bsh"];
    [taskImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.5, 0.5, 0, 0)];
    [self.labeBackView setImage:taskImage];
    self.headerImageView.layer.cornerRadius = 3;
    self.headerImageView.layer.masksToBounds = YES;
}

- (void)updateMode:(TBTaskListRoot*)list share:(BOOL)share taskStatus:(Tasktype)state;
{
    self.mode = list;
    self.cellTasktype = state;
    
    NSString *lastName = @"";// 最后一个按钮的名称
    NSString  *twoButtonName = @"";// 第二个Button的名称
    NSInteger buttonNumber = 0;// 按钮数量
    CGFloat   buttonActivationWidth = 0.01f;
    CGFloat  cellButtonWidth;// 审核按钮的宽
    switch (state) {
        case TasktypeThrough:// 已通过
            twoButtonName = @"";
            buttonNumber = 2;
            break;
        case TasktypeNotThrough:// 未通过
            twoButtonName = @"审核详情";
            buttonNumber = 3;
            break;
        case TasktypeToAudit:// 待审核
            twoButtonName = @"";
            buttonNumber = 2;
            break;
            
        default:
            break;
    }
    // 最后一个按钮名称判断
    if ([list.abcbankstate isEqualToString:@"0"]) {
        
        lastName = @"绑定台卡";
    }
    else if ([list.abcbankstate isEqualToString:@"2"])
    {
        lastName = @"验证详情";
    }else
    {
        lastName = @"激活";
    }
    
    if ([list.isbind isEqualToString:@"1"])
    {
        buttonActivationWidth = 0.0f;
        cellButtonWidth = ((_SCREEN_WIDTH - buttonNumber+1)/buttonNumber);
        
    }
    else
    {
        buttonNumber = buttonNumber + 1;
        cellButtonWidth = ((_SCREEN_WIDTH - buttonNumber+1)/buttonNumber);
        buttonActivationWidth = cellButtonWidth;
    }
    
    if (state == TasktypeNotThrough)
    {
        self.detailsWidth.constant = cellButtonWidth;
    }
    else
    {
        self.detailsWidth.constant = 0.01f;
        
    }
    
    self.activationWidth.constant = buttonActivationWidth;
    [self.twoButton setTitle:twoButtonName forState:UIControlStateNormal];
    [self.lastButton setTitle:lastName forState:UIControlStateNormal];
    
    [ZKUtil downloadImage:self.headerImageView imageUrl:list.img duImageName:@"homeDefault"];
    
    self.nameLabel.text = list.name;
    self.telLabel.text = list.tel;
    self.adderssLabel.text = list.address;
    
    share = ![list.code isEqualToString:@"service"];
    if (list.price.doubleValue == 0)
    {
        self.labeBackView.hidden = YES;
        self.packageLabel.hidden = YES;
    }
    else
    {
        self.labeBackView.hidden = NO;
        self.packageLabel.hidden = NO;
        self.packageLabel.text = [NSString stringWithFormat:@"%@元套餐",list.price];
    }
    
    self.shareButton.enabled = share;
    self.shareButton.alpha = share?1.0f:0.3f;
    self.typeLabel.text = list.type;
}

#pragma mark  --- uibutton ---
- (IBAction)editorClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(taskCellClickEditorMode:)])
    {
        [self.delegate taskCellClickEditorMode:self.mode];
    }
}
- (IBAction)detailsClick:(UIButton *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(taskCellClickDetailsMode:)])
    {
        [self.delegate taskCellClickDetailsMode:self.mode];
    }
    
}
- (IBAction)shareClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(taskCellClickShareMode:)])
    {
        [self.delegate taskCellClickShareMode:self.mode];
    }
}
- (IBAction)activationClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(taskCellClickActivationMode:)]) {
        [self.delegate taskCellClickActivationMode:self.mode];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
