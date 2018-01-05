//
//  UIImage+Strenching.m
//  slyjg
//
//  Created by 汤亮 on 16/5/17.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "UIImage+Strenching.h"

@implementation UIImage (Strenching)

- (UIImage *)strechingMiddle
{
    return [self stretchableImageWithLeftCapWidth:self.size.width / 2 topCapHeight:self.size.height / 2];
}

- (UIImage *)strechingAtPoint:(CGPoint)point
{
    return [self stretchableImageWithLeftCapWidth:self.size.width * point.x topCapHeight:self.size.height * point.y];
}

@end
