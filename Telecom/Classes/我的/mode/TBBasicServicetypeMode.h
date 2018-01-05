//
//  TBBasicServicetypeMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBBasicServicetypeRange,TBBasicServicetypeServicelables,TBBasicServicetypeLabels;

@interface TBBasicServicetypeMode : NSObject

@property (nonatomic, strong) NSArray<TBBasicServicetypeRange *> *range;

@property (nonatomic, strong) NSArray<TBBasicServicetypeServicelables *> *servicelables;

@end

@interface TBBasicServicetypeRange : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end


@interface TBBasicServicetypeServicelables : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, strong) NSArray<TBBasicServicetypeLabels *> *labels;

@property (nonatomic, copy) NSString *name;

@end

@interface TBBasicServicetypeLabels : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *pname;

@property (nonatomic, copy) NSString *name;

@end

