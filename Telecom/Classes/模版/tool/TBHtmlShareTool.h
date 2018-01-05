//
//  TBHtmlShareTool.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/16.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBHtmlShareTool : UIView

/**
 分享到微信

 @param title 标题
 @param info 内容
 @param image 图片
 @param webUrl 网页链接
 */
- (void)showWXTitle:(NSString *)title deacription:(NSString *)info image:(id)image webpageUrl:(NSString *)webUrl;

@end
