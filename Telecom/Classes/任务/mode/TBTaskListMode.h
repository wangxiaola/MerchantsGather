//
//  TBTaskListMode.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBTaskListData,TBTaskListShops,TBTaskListRoot;
@interface TBTaskListMode : NSObject

@property (nonatomic, strong) TBTaskListData *data;

@end


@interface TBTaskListData : NSObject

@property (nonatomic, strong) TBTaskListShops *shops;

@end

@interface TBTaskListShops : NSObject

@property (nonatomic, copy) NSString *number;

@property (nonatomic, assign) NSInteger snum;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, strong) NSArray<TBTaskListRoot *> *root;

@property (nonatomic, assign) NSInteger total;

@end

@interface TBTaskListRoot : NSObject

@property (nonatomic, copy) NSString *abcbankdesc;

@property (nonatomic, copy) NSString *abcbankstate;

@property (nonatomic, copy) NSString *isbind;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) NSInteger isnew;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *logo2;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, assign) NSInteger shopstate;

@property (nonatomic, assign) NSInteger mid;


@end

