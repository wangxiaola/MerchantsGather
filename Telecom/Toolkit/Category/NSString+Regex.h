//
//  NSString+Regex.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/25.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)
//判断是否是手机号码
- (BOOL)isTelephone;
//判断是否是身份证号
- (BOOL)isIDCard;
@end
