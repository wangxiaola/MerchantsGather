
//
//  HomeCollectionViewCell.m
//  Telecom
//
//  Created by zhangxingdong 张兴栋 on 16/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "TBHomeDataMode.h"

@implementation HomeCollectionViewCell
{
    UIView *contenview;
    
    UIImageView *imageView;
    
    UILabel *nameLabel;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUPImageView];

    }
    return self;
}

- (void)setUPImageView
{
    contenview = [[UIView alloc] init];
    contenview.backgroundColor = [UIColor whiteColor];
    contenview.layer.cornerRadius = 4;
    contenview.clipsToBounds = YES;
    contenview.layer.borderColor = BODER_COLOR.CGColor;
    contenview.layer.borderWidth = 0.5;
    [self addSubview:contenview];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeDefault.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [contenview addSubview:imageView];
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor grayColor];
    nameLabel.numberOfLines = 1;
    nameLabel.backgroundColor = [UIColor whiteColor];
//    nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [contenview addSubview:nameLabel];
    TBWeakSelf
    [contenview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
        
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(contenview);
        make.height.mas_equalTo(0);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(contenview);
        make.bottom.equalTo(nameLabel.mas_top).offset(0);
    }];
}

- (void)cellAssignmentData:(id)list showLabel:(BOOL)show;
{
    NSString *url;
    NSString *name;
    
    if ([list isKindOfClass:[TBHomeModelsRoot class]])
    {
        TBHomeModelsRoot *root = list;
        url = root.logo;
        name = root.title;
    }
    else if ([list isKindOfClass:[TBHomeShopsRoot class]])
    {
        TBHomeShopsRoot *root = list;
        url = root.logo;
        name = root.name;
    }
    
    [ZKUtil downloadImage:imageView imageUrl:url duImageName:@"homeDefault.jpg"];
    nameLabel.text = name;
    
    float nameLabelHeight = show?30.0f:0.0f;
    [nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(nameLabelHeight);
    }];
}

@end
