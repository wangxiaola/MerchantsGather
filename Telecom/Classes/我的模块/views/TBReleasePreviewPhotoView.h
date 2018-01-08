//
//  TBReleasePreviewPhotoView.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 发布预览头部图片
 */
@interface TBReleasePreviewPhotoView : UIView

/**
 更新布局显示

 @param array 图片数组
 @param name 名称
 */
- (void)updataPhotoArray:(NSArray *)array photoName:(NSString *)name;
@end
