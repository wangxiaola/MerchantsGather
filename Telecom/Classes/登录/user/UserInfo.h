//
//  MDAccount.h
//  slyjg
//
//  Created by 汤亮 on 16/8/22.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic, copy, nullable) NSString *headimg;
@property (nonatomic, copy, nullable) NSString *userID;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *phone;
@property (nonatomic, copy, nullable) NSString *type;
@property (nonatomic, copy, nullable) NSString *code;
@property (nonatomic, copy, nullable) NSString *domain;

+ (nonnull UserInfo *)account;

+ (void)saveAccount:(nullable UserInfo *)account;
@end
