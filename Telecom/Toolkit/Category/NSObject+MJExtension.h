//
//  NSObject+MJExtension.h
//  CountryTouristAdministration
//
//  Created by 汤亮 on 16/8/1.
//  Copyright © 2016年 daqsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MJExtension)

+ (NSMutableArray *)dq_objectArrayWithKeyValuesArray:(id)keyValuesArray;

+ (instancetype)dq_objectWithKeyValues:(id)keyValues;

@end
