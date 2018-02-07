//
//  FMLScaledImageViewCell.m
//  VideoClip
//
//  Created by samo on 16/9/2.
//  Copyright © 2016年 Collion. All rights reserved.
//

#import "FMLScaledImageViewCell.h"

@interface FMLScaledImageViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *scaledIamgeView;

@end

@implementation FMLScaledImageViewCell

- (void)setImageData:(NSString *)filePath
{
    if (filePath.length > 0) {

        UIImage *image = [UIImage imageWithContentsOfFile:filePath];;
        self.scaledIamgeView.image = image;
    }

}

@end
