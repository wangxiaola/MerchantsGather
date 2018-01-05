//
//  TBChoosePhotosTool.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/12.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBChoosePhotosToolDelegate <NSObject>

@optional

- (void)choosePhotosArray:(NSArray<UIImage*>*)images;

@end
/**
 选择相片工具
 */
@interface TBChoosePhotosTool : NSObject

@property (weak, nonatomic) id<TBChoosePhotosToolDelegate>delegate;

/**
 弹出相册选择

 @param number 最多可以选择几张
 */
- (void)showPhotosIndex:(NSInteger)number;

/**
 预览相片

 @param array 相片集合
 @param view 源自那张弹出
 @param num 选中第几张
 */
- (void)showPreviewPhotosArray:(NSArray *)array baseView:(UIImageView*)view selected:(NSInteger)num;


/**
 头像图片选择（裁剪）

 @param controller vc
 */
- (void)showHeadToChooseViewController:(UIViewController *)controller;

@end
