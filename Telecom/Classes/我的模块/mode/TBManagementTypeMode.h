//
//  TBManagementTypeMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBManagementRoot;
@interface TBManagementTypeMode : NSObject

@property (nonatomic, copy) NSString *number;

@property (nonatomic, assign) NSInteger snum;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, strong) NSArray<TBManagementRoot *> *root;

@property (nonatomic, assign) NSInteger total;

@end



@interface TBManagementRoot : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger mid;

@property (nonatomic, assign) NSInteger isnew;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, assign) NSInteger shopstate;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *logo2;


@end

