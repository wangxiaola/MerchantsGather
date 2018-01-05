//
//  UIStoryboard+Initialize.h
//  CountryTouristAdministration
//
//  Created by 汤亮 on 16/7/11.
//  Copyright © 2016年 daqsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define vcFromStoryboard(name, vcId) [UIStoryboard vcWithStoryboardName:name forVcId:vcId]

@interface UIStoryboard (Initialize)
+ (UIViewController *)vcWithStoryboardName:(NSString *)name forVcId:(NSString *)vcId;
@end
