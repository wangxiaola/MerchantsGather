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

- (void)setImageData:(UIImage *)filePath
{
    if (filePath) {
        [self.scaledIamgeView setImage:filePath];
    }

}

@end
