//
//  TBGroupPhotoChooseView.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/13.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 团购照片选择
 */
@interface TBGroupPhotoChooseView : UIView

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *imageArray;
/**
 更新选择相册高度
 */
@property (nonatomic, strong) void(^updataPhotoViewHeight)(CGFloat height);

- (void)updataCollectionView;
@end
