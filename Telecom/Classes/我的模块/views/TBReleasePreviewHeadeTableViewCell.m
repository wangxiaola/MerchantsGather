//
//  TBReleasePreviewHeadeTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBReleasePreviewHeadeTableViewCell.h"

@implementation TBReleasePreviewHeadeTableViewCell
{
    UILabel *_nameLable;
    UIButton *showButton;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
       _nameLable = [[UILabel alloc] init];
       _nameLable.textColor = [UIColor blackColor];
       _nameLable.font = [UIFont systemFontOfSize:15];
       [self addSubview:_nameLable];
       
        showButton = [UIButton buttonWithType:UIButtonTypeCustom];
       [showButton setImage:[UIImage imageNamed:@"task-top"] forState:UIControlStateNormal];
       showButton.selected = YES;
       [showButton addTarget:self action:@selector(showClick:) forControlEvents:UIControlEventTouchUpInside];
       [self addSubview:showButton];
       TBWeakSelf
       [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(weakSelf.mas_left).offset(8);
           make.centerY.equalTo(weakSelf.mas_centerY);
       }];
       [showButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(weakSelf.mas_right).offset(-8);
           make.centerY.equalTo(weakSelf.mas_centerY);
           make.width.equalTo(@40);
           make.height.equalTo(@40);
       }];

    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updataText:(NSString *)text state:(BOOL)show buttonClick:(Cellheight)isShow;
{
    self.cellheight = isShow;
    _nameLable.text = text;
    NSString *showName = show == YES?@"task-top":@"task-botton";
    [showButton setImage:[UIImage imageNamed:showName] forState:UIControlStateNormal];
}
- (void)showClick:(UIButton *)sender
{
    if (self.cellheight)
    {
        self.cellheight();
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
