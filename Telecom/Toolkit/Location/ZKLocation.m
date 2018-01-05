//
//  ZKLocation.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/3.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKLocation.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface ZKLocation ()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@end
@implementation ZKLocation

- (instancetype)init
{
    if (self = [super init])
    {
        
    }
    return self;
}
#pragma mark - public
- (void)beginUpdatingLocation
{
    
    [self initCompleteBlock];
    [self configLocationManager];
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}
#pragma mark - Action Handle

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout = 5;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 5;
}

- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
}

#pragma mark - Initialization

- (void)initCompleteBlock
{
    __weak ZKLocation *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            if ([weakSelf.delegate respondsToSelector:@selector(locationDidFailWithError)]) {
                [weakSelf.delegate locationDidFailWithError];
            }
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            if ([weakSelf.delegate respondsToSelector:@selector(locationDidFailWithError)]) {
                [weakSelf.delegate locationDidFailWithError];
            }
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            
            if ([weakSelf.delegate respondsToSelector:@selector(locationDidFailWithError)]) {
                [weakSelf.delegate locationDidFailWithError];
            }
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
            
            if ([weakSelf.delegate respondsToSelector:@selector(locationDidEndUpdatingLocation:)] && regeocode) {
                Location *mode = [[Location alloc] init];
                
                NSString *province = regeocode.province.length == 0?@"":regeocode.province;
                NSString *city = regeocode.city.length == 0?@"":regeocode.city;
                NSString *district = regeocode.district.length == 0?@"":regeocode.district;
                
                mode.formattedAddress = [NSString stringWithFormat:@"%@%@%@%@",province,city,district,regeocode.POIName];
                mode.latitude = location.coordinate.latitude;
                mode.longitude = location.coordinate.longitude;
                
                [weakSelf.delegate locationDidEndUpdatingLocation:mode];
            }
        }
        
    };
}
- (void)dealloc
{
    [self cleanUpAction];
    self.completionBlock = nil;
}
@end

