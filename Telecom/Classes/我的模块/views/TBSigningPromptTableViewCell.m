//
//  TBSigningPromptTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/5/15.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBSigningPromptTableViewCell.h"

@implementation TBSigningPromptTableViewCell
{

    __weak IBOutlet UILabel *infoLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [ZKUtil changeLineSpaceForLabel:infoLabel WithSpace:5];
}
- (void)assignmentText:(NSString *)name;
{
    infoLabel.text = name;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
