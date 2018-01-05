//
//  TBFilterCollectionViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/12/26.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBFilterCollectionViewCell.h"

@implementation TBFilterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_filtrt"]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
        [self.contentView setTransform:transform];
        
        TBWeakSelf
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(weakSelf.contentView);
            make.bottom.equalTo(weakSelf.nameLabel.mas_top);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf.contentView);
            make.height.equalTo(@30);
        }];
        
    }
    return self;
}
/**
 设置滤镜
 
 @param filtrt 滤镜
 @param name 滤镜名称
 */
- (void)setCellViewsFilter:(CIFilter *)filtrt filtrtName:(NSString *)name;
{
    if (filtrt == nil)
    {
           self.imageView.image = [UIImage imageNamed:@"video_filtrt"];
    }
    else
    {
        CIImage* oldImg = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"video_filtrt"]];
        [filtrt setValue:oldImg forKey:@"inputImage"];
        UIImage* newImg = [UIImage imageWithCIImage:[filtrt outputImage]];
        self.imageView.image = newImg;
    }

    self.nameLabel.text = name;
}

@end
