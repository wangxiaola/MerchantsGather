//
//  TBManagementTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBManagementTableViewCell.h"
#import "TBManagementTypeMode.h"

@interface TBManagementTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *labeBackView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *adderssLabel;

@property (nonatomic, strong) TBManagementRoot *mode;
@end
@implementation TBManagementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *taskImage = [UIImage imageNamed:@"tast_bsh"];
    [taskImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.5, 0.5, 0, 0)];
    [self.labeBackView setImage:taskImage];
    self.headerImageView.layer.cornerRadius = 3;
    self.headerImageView.layer.masksToBounds = YES;
}

- (void)updateMode:(TBManagementRoot*)list;
{
    self.mode = list;
    [ZKUtil downloadImage:self.headerImageView imageUrl:list.img duImageName:@"homeDefault"];
    self.nameLabel.text = list.name;
    self.telLabel.text = list.tel;
    self.adderssLabel.text = list.address;
    self.taskTypeLabel.text = list.type;
    if ([list.code isEqualToString:@"service"])
    {
        self.labeBackView.hidden = YES;
        self.typeLabel.hidden = YES;
    }
    else
    {
        self.labeBackView.hidden = NO;
        self.typeLabel.hidden = NO;
        self.typeLabel.text = [NSString stringWithFormat:@"%ld元套餐",(long)list.price];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
