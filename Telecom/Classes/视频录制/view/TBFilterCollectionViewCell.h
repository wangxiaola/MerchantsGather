//
//  TBFilterCollectionViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/12/26.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBFilterCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel     *nameLabel;


/**
 设置滤镜

 @param filtrt 滤镜
 @param name 滤镜名称
 */
- (void)setCellViewsFilter:(CIFilter *)filtrt filtrtName:(NSString *)name;

@end
