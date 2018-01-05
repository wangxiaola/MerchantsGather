//
//  TBTemplateChooseCollectionViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTemplateChooseCollectionViewCell.h"
#import "TBHomeDataMode.h"

@interface TBTemplateChooseCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation TBTemplateChooseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.borderColor = BODER_COLOR.CGColor;
    self.contentView.layer.borderWidth = 0.6;
}

- (void)setModels:(TBHomeModelsRoot *)models
{
    [ZKUtil downloadImage:self.backImageView imageUrl:models.logo duImageName:@"homeDefault.jpg"];
    self.nameLabel.text = models.title;
}
@end
