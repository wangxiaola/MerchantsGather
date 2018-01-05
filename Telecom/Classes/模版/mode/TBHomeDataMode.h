//
//  TBHomeDataMode.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/15.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBHomeData,TBHomeShops,TBHomeModelsRoot,TBHomeModels,TBHomeShopsRoot;
@interface TBHomeDataMode : NSObject


@property (nonatomic, copy) NSString *errcode;

@property (nonatomic, strong) TBHomeData *data;


@end
@interface TBHomeData : NSObject

@property (nonatomic, strong) TBHomeShops *shops;

@property (nonatomic, strong) TBHomeModels *models;

@end

@interface TBHomeShops : NSObject

@property (nonatomic, copy) NSString *number;

@property (nonatomic, assign) NSInteger snum;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, strong) NSArray<TBHomeShopsRoot *> *root;

@property (nonatomic, assign) NSInteger total;

@end

@interface TBHomeShopsRoot : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) NSInteger isnew;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, copy) NSString *name;

@end

@interface TBHomeModels : NSObject

@property (nonatomic, copy) NSString *number;

@property (nonatomic, assign) NSInteger snum;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, strong) NSArray<TBHomeModelsRoot *> *root;

@property (nonatomic, assign) NSInteger total;

@end

@interface TBHomeModelsRoot : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *logo;

@end

