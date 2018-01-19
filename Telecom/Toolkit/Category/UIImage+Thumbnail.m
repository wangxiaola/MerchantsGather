//
//  UIImage+Thumbnail.m
//  slyjg
//
//  Created by 汤亮 on 16/4/25.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "UIImage+Thumbnail.h"

@implementation UIImage (Thumbnail)
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor =0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if(CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor)
            scaleFactor = widthFactor;// scale to fit height
        else
            scaleFactor = heightFactor;// scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if(widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) *0.5;
        }
        else
            if(widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) *0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize);// this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        MMLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)compressionCap:(CGFloat)coefficient{
    
    // 如果传入的宽度比当前宽度还要大,就直接返回
    CGRect  rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    if (self.size.width <1000||self.size.height<1000)
    {
        return self;
    }
    if (coefficient > self.size.width) {
        
        // 计算缩放之后的高度
        
        CGFloat height = (coefficient * self.size.height) / self.size.width;
        // 初始化要画的大小
        
        rect = CGRectMake(0, 0, coefficient, height);
        
    }
    if (rect.size.height>coefficient)
    {
        CGFloat width = (coefficient*self.size.width)/self.size.height;
        rect = CGRectMake(0, 0, width, coefficient);
    }


    // 1. 开启图形上下文
    
    UIGraphicsBeginImageContext(rect.size);
    
    // 2. 画到上下文中 (会把当前image里面的所有内容都画到上下文)
    
    [self drawInRect:rect];
    
    // 3. 取到图片
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4. 关闭上下文
    
    UIGraphicsEndImageContext();
    
    // 5. 返回
    
    return image;
    
}
- (void)compressToDataLength:(NSInteger)length withBlock :(void (^)(NSData *))block {
    if (length <= 0 || [self isKindOfClass:[NSNull class]] || self == nil) block(nil);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *newImage = [self copy];
        {
            CGFloat scale = 0.9;
            NSData *pngData = UIImagePNGRepresentation(self);
            MMLog(@"Original pnglength %zd", pngData.length);
            NSData *jpgData = UIImageJPEGRepresentation(self, scale);
            MMLog(@"Original jpglength %zd", pngData.length);
            
            while (jpgData.length > length) {
                newImage = [newImage compressWithWidth:newImage.size.width * scale];
                NSData *newImageData = UIImageJPEGRepresentation(newImage, 0.0);
                if (newImageData.length < length) {
                    CGFloat scale = 1.0;
                    newImageData = UIImageJPEGRepresentation(newImage, scale);
                    while (newImageData.length > length) {
                        scale -= 0.1;
                        newImageData = UIImageJPEGRepresentation(newImage, scale);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MMLog(@"Result jpglength %zd", newImageData.length);
                        block(newImageData);
                    });
                    return;
                }
            }
        }
    });
}

- (void)tryCompressToDataLength:(NSInteger)length withBlock:(void (^)(NSData *))block {
    if (length <= 0 || [self isKindOfClass:[NSNull class]] || self == nil) block(nil);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGFloat scale = 0.9;
        NSData *scaleData = UIImageJPEGRepresentation(self, scale);
        while (scaleData.length > length) {
            scale -= 0.1;
            if (scale < 0) {
                break;
            }
            MMLog(@"%f", scale);
            scaleData = UIImageJPEGRepresentation(self, scale);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block(scaleData);
        });
    });
}
- (UIImage *)compressWithWidth:(CGFloat)width {
    if (width <= 0 || [self isKindOfClass:[NSNull class]] || self == nil) return nil;
    CGSize newSize = CGSizeMake(width, width * (self.size.height / self.size.width));
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
