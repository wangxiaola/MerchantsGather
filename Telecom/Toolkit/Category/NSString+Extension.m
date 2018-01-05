//
//  NSString+Extension.m
//  CountryTouristAdministration
//
//  Created by LiDinggui on 16/8/17.
//  Copyright © 2016年 daqsoft. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

//判断字符串是否为空
+ (BOOL)isEmptyWithStr:(NSString *)str
{
    if (!str)
    {
        return YES;
    }
    else
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if (trimedString.length == 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

+ (NSString *)ifIsEmptyWithStr:(NSString *)str
{
    if ([NSString isEmptyWithStr:str])
    {
        return @"";
    }
    else
    {
        return str;
    }
}

+ (BOOL)isNonNegativeIntegerWithStr:(NSString *)str
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[1-9]\\d*|0$"];
    return [predicate evaluateWithObject:str];
}

+ (NSString *)nonNegativeIntegerTranslateToMicrometerDelimiterStyleWithStr:(NSString *)str
{
    if ([self isEmptyWithStr:str])
    {
        return @"0";
    }
    
    if (![self isNonNegativeIntegerWithStr:str])
    {
        return @"0";
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.positiveFormat = @"###,##0";
    return [numberFormatter stringFromNumber:@(str.integerValue)];
}

@end
