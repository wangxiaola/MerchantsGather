//
//  UIImageView+SDWebCache.m
//  guide
//
//  Created by 汤亮 on 15/10/8.
//  Copyright © 2015年 daqsoft. All rights reserved.
//

#import "UIImageView+ZKWebCache.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (ZKWebCache)

- (void)zk_setImageWithURL:(NSString *)url
{
    if (![url containsString:IMAGE_URL]) {
        url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
    }
    [self sd_setImageWithURL:[NSURL URLWithString:url]];

}

- (void)zk_setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    if (![url containsString:IMAGE_URL]) {
        url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
    }
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}

@end
