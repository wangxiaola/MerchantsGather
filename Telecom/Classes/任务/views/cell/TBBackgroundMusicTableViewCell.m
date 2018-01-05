//
//  TBBackgroundMusicTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/14.
//  Copyright © 2016年 王小腊. All rights reserved.
//

NSString *const TBBackgroundMusicTableViewCellID = @"TBBackgroundMusicTableViewCellID";

#import "TBBackgroundMusicTableViewCell.h"

@interface TBBackgroundMusicTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagView;
@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;


@end
@implementation TBBackgroundMusicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.tagView.hidden = YES;
}

- (void)setData:(TBTemplateBackgroundData *)data
{
    _data = data;
    if (data)
    {
        self.tagView.hidden = NO;
        self.nameLabel.text = data.name;
        self.numberLabel.text = [NSString stringWithFormat:@"%@人选用",data.count];
    }else
    {
        self.tagView.hidden = YES;
        self.nameLabel.text = @"无音乐";
        self.numberLabel.text = @"";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    NSString *imageName = selected?@"task-choice-hover":@"task-choice";
    self.musicImageView.image = [UIImage imageNamed:imageName];
    
    if (self.data)
    {
        self.tagView.hidden = !selected;
    }
    else
    {
       self.tagView.hidden = YES;
    }

    // Configure the view for the selected state
}

@end
