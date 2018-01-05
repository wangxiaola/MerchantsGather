//
//  TBRegionESRootClass.h
//  Telecom
//
//  Created by 王小腊 on 2017/7/17.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TBRegionData,TBRegionCityChildren,TBRegionAreaChildren;
@interface TBRegionESRootClass : NSObject

@property (nonatomic, strong) NSString *errcode;

@property (nonatomic, strong) NSArray<TBRegionData *> *data;

@end
@interface TBRegionData : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<TBRegionCityChildren *> *children;

@property (nonatomic, copy) NSString *parent;

@end

@interface TBRegionCityChildren : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSArray<TBRegionAreaChildren *> *children;

@end

@interface TBRegionAreaChildren : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *children;

@end



