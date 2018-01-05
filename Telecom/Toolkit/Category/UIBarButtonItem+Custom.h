//
//  UIBarButtonItem+Custom.h
//  guide
//
//  Created by 汤亮 on 15/10/6.
//  Copyright © 2015年 daqsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Custom)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)setRitWithTitel:(NSString *)string itemWithIcon:(NSString *)icon target:(id)target action:(SEL)action;

@end
