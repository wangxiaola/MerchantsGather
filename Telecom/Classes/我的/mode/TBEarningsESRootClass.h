//
//  TBEarningsESRootClass.h
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TBEarningsRoot,TBEarningsDetails;
@interface TBEarningsESRootClass : NSObject

@property (nonatomic, copy) NSString *number;

@property (nonatomic, assign) NSInteger snum;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, strong) NSArray<TBEarningsRoot *> *root;

@property (nonatomic, assign) NSInteger total;

@end
@interface TBEarningsRoot : NSObject

@property (nonatomic, assign) CGFloat monthmoney;

@property (nonatomic, strong) NSArray<TBEarningsDetails *> *details;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *month;

@property (nonatomic, assign) CGFloat monthpay;

@end

@interface TBEarningsDetails : NSObject

@property (nonatomic, copy) NSString *paytime;

@property (nonatomic, assign) CGFloat paymoney;

@property (nonatomic, copy) NSString *headimg;

@property (nonatomic, assign) CGFloat totalincome;

@property (nonatomic, assign) CGFloat totalmoney;

@property (nonatomic, assign) CGFloat money;

@property (nonatomic, copy) NSString *shopname;

@end


