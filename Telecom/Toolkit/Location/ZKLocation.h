//
//  ZKLocation.h
//  Emergency
//
//  Created by 王小腊 on 2017/7/3.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@protocol ZKLocationDelegate;

@interface ZKLocation : NSObject

@property (nonatomic, weak) id<ZKLocationDelegate> delegate;

- (void)beginUpdatingLocation;
@end

@protocol ZKLocationDelegate <NSObject>
@optional
- (void)locationDidEndUpdatingLocation:(Location *)location;
/**
 定位异常
 */
- (void)locationDidFailWithError;
@end
