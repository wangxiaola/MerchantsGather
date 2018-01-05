//
//  UIStoryboard+Initialize.m
//  CountryTouristAdministration
//
//  Created by 汤亮 on 16/7/11.
//  Copyright © 2016年 daqsoft. All rights reserved.
//

#import "UIStoryboard+Initialize.h"

@implementation UIStoryboard (Initialize)

+ (UIViewController *)vcWithStoryboardName:(NSString *)name forVcId:(NSString *)vcId
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UIViewController *vc = nil;
    if (vcId) {
        vc = [storyboard instantiateViewControllerWithIdentifier:vcId];
    }else {
        vc = [storyboard instantiateInitialViewController];
    }
    return vc;
}

@end
