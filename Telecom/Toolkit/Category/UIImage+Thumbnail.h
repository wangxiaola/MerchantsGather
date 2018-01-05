//
//  UIImage+Thumbnail.h
//  slyjg
//
//  Created by 汤亮 on 16/4/25.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZKThumbnailImage(originalImage, targetSize) \
[originalImage imageByScalingAndCroppingForSize:targetSize]

@interface UIImage (Thumbnail)
//将图片变成指定大小的缩略图
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;


/**
 按最高系数压缩

 @param coefficient 系数  如1000  宽和高都不得超过1000
 @return self
 */
- (UIImage *)compressionCap:(CGFloat)coefficient;

/// 将图片在子线程中压缩，block在主线层回调，保证压缩到指定文件大小，尽量减少失真
- (void)compressToDataLength:(NSInteger)length withBlock:(void(^)(NSData *data))block;
/// 尽量将图片压缩到指定大小，不一定满足条件
- (void)tryCompressToDataLength:(NSInteger)length withBlock:(void(^)(NSData *data))block;

@end
