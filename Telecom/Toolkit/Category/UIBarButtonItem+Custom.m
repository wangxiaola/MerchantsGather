//
//  UIBarButtonItem+Custom.m
//  guide
//
//  Created by 汤亮 on 15/10/6.
//  Copyright © 2015年 daqsoft. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"
#import "UIButton+ImageTitleStyle.h"
@implementation UIBarButtonItem (Custom)

+ (UIBarButtonItem *)setRitWithTitel:(NSString *)string itemWithIcon:(NSString *)icon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:string forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CGSize titleSize = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:button.titleLabel.font.fontName size:button.titleLabel.font.pointSize]}];
    titleSize.height = 24;
    titleSize.width += 6;
    
    button.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (icon.length > 0)
    {
     UIImage *image = [UIImage imageNamed:icon];
     [button setImage:image forState:UIControlStateNormal];
     button.frame = (CGRect){CGPointZero, CGSizeMake(image.size.width+titleSize.width, 30)};
     [button setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:2];
    }

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (icon) {
        [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
    if (highIcon) {
        [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    }
    button.selected = NO;
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
