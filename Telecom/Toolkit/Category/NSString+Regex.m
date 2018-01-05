//
//  NSString+Regex.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/25.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

- (BOOL)isTelephone
{
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
//    
//    return  [regextestmobile evaluateWithObject:self]   ||
//    [regextestphs evaluateWithObject:self]      ||
//    [regextestct evaluateWithObject:self]       ||
//    [regextestcu evaluateWithObject:self]       ||
//    [regextestcm evaluateWithObject:self];
    
    NSString *pattern = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"; // ^1+[34578]+\\d{9}
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)isIDCard
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

@end
