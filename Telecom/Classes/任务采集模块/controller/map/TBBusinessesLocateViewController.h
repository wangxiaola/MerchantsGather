//
//  TBBusinessesLocateViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/15.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLLocation;

@interface TBBusinessesLocateViewController : UIViewController

@property (nonatomic, assign ) double  latitude;

@property (nonatomic, assign ) double  longitude;

@property (nonatomic, copy) void(^userLocation)(NSString*address,double lat,double lon);

@end
