//
//  TBReleasePreviewPhotoView.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBReleasePreviewPhotoView.h"
#import "TBChoosePhotosTool.h"
@implementation TBReleasePreviewPhotoView
{
    UIImageView *_photoImageView;
    UILabel *_photoNameLabel;
    UIButton *_numberButton;
    NSArray *_photoArray;
    TBChoosePhotosTool *_photosTool;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"productDefault"]];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
        [self addSubview:_photoImageView];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addSubview:bottomView];
        
        _photoNameLabel = [[UILabel alloc] init];
        _photoNameLabel.textColor = [UIColor whiteColor];
        _photoNameLabel.font = [UIFont systemFontOfSize:14];
        [bottomView addSubview:_photoNameLabel];
        
        _numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _numberButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_numberButton setTitle:@" 0张" forState:UIControlStateNormal];
        [_numberButton setImage:[UIImage imageNamed:@"preview_photo"] forState:UIControlStateNormal];
        [bottomView addSubview:_numberButton];
        
        UIButton *touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [touchButton addTarget:self action:@selector(imageClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:touchButton];
        
        TBWeakSelf
        [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf);
            make.height.equalTo(@40);
        }];
        
        [_photoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomView.mas_left).offset(10);
            make.centerY.equalTo(bottomView.mas_centerY);
        }];
        
        [_numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomView.mas_right).offset(-10);
            make.height.equalTo(@26);
            make.centerY.equalTo(bottomView.mas_centerY);
        }];
        
        [touchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        _photosTool = [[TBChoosePhotosTool alloc] init];
    }
    return self;
}
/**
 更新布局显示
 
 @param array 图片数组
 @param name 名称
 */
- (void)updataPhotoArray:(NSArray *)array photoName:(NSString *)name;
{
    _photoArray = array;
    id image = array.firstObject;
    if ([image isKindOfClass:[UIImage class]])
    {
        [_photoImageView setImage:image];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        [ZKUtil downloadImage:_photoImageView imageUrl:image duImageName:@"productDefault"];
    }
    _photoNameLabel.text = name;
   [_numberButton setTitle:[NSString stringWithFormat:@" %lu张",(unsigned long)array.count] forState:UIControlStateNormal];
}
- (void)imageClick
{
    [_photosTool showPreviewPhotosArray:_photoArray baseView:_photoImageView selected:0];
}
@end
