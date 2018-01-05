//
//  MDAccount.m
//  slyjg
//
//  Created by 汤亮 on 16/8/22.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "UserInfo.h"

#define MDACCOUNT_PATH [kDocumentPath stringByAppendingPathComponent:@"UserInfo.data"]

@implementation UserInfo

MJCodingImplementation

+ (nonnull UserInfo *)account
{
    UserInfo *account = [NSKeyedUnarchiver unarchiveObjectWithFile:MDACCOUNT_PATH];
    return account ? : [[UserInfo alloc] init];
}

+ (void)saveAccount:(nullable UserInfo *)account
{
    [NSKeyedArchiver archiveRootObject:account ? : [[UserInfo alloc] init] toFile:MDACCOUNT_PATH];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userID": @"id"};
}

@end
