//
//  Location.h
//  Emergency
//
//  Created by 王小腊 on 2017/7/3.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject

//国家
@property (nonatomic, copy) NSString * country;
//省 直辖市
@property (nonatomic, copy) NSString * administrativeArea;
// 地级市 直辖市区
@property (nonatomic, copy) NSString * locality;
//县 区
@property (nonatomic, copy) NSString * subLocality;
//街道
@property (nonatomic, copy) NSString * thoroughfare;
//子街道
@property (nonatomic, copy) NSString * subThoroughfare;
///兴趣点名称
//@property (nonatomic, copy) NSString *POIName;
//经度
@property (nonatomic, assign) CLLocationDegrees longitude;
//纬度
@property (nonatomic, assign) CLLocationDegrees latitude;

///格式化地址
@property (nonatomic, copy) NSString *formattedAddress;
@end
