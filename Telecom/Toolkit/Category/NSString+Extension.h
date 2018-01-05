//
//  NSString+Extension.h
//  CountryTouristAdministration
//
//  Created by LiDinggui on 16/8/17.
//  Copyright © 2016年 daqsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

//判断字符串是否为空
+ (BOOL)isEmptyWithStr:(NSString *)str;

+ (NSString *)ifIsEmptyWithStr:(NSString *)str;

//判断字符串是否为非负整数
+ (BOOL)isNonNegativeIntegerWithStr:(NSString *)str;

//非负整数转化为带有千分位分隔符的样式###,##0
+ (NSString *)nonNegativeIntegerTranslateToMicrometerDelimiterStyleWithStr:(NSString *)str;

@end
