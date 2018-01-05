//
//  UIImageView+SDWebCache.h
//  guide
//
//  Created by 汤亮 on 15/10/8.
//  Copyright © 2015年 daqsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ZKWebCache)
- (void)zk_setImageWithURL:(NSString *)url;
- (void)zk_setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;
@end
