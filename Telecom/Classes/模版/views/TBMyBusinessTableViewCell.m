//
//  TBMyBusinessTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/1/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBMyBusinessTableViewCell.h"

NSString *const TBMyBusinessTableViewCellID = @"TBMyBusinessTableViewCellID";
@interface TBMyBusinessTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, strong) TBHomeShopsRoot *rootMode;

@end
@implementation TBMyBusinessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.layer.cornerRadius = 3.0;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.clipsToBounds = YES;
    // Initialization code
}
- (void)cellUIAssignmentMode:(TBHomeShopsRoot *)mode showShare:(BOOL)show;
{
    self.rootMode = mode;
    [ZKUtil downloadImage:_headerImageView imageUrl:mode.logo duImageName:@"imageDefault.jpg"];
    self.nameLabel.text = mode.name;
    self.addressLabel.text = mode.address;
    self.timeLabel.text = mode.tel;
    self.shareButton.enabled = show;
    self.shareButton.alpha = show?1.0f:0.4f;
}
#pragma mark ----UIButton----
- (IBAction)editorClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(businessCellClickEditorMode:)]) {
        [self.delegate businessCellClickEditorMode:_rootMode];
    }
}
- (IBAction)shareClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(businessCellClickShareMode:)]) {
        [self.delegate businessCellClickShareMode:_rootMode];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
