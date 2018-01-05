
//
//  TBBusinessesLocateViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/15.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBusinessesLocateViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "TBShowAddressResultsView.h"
#import "TBNoticePromptBoxView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface TBBusinessesLocateViewController ()<MAMapViewDelegate,AMapSearchDelegate>

@property (nonatomic, strong) NSString *currentCity;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) AMapReGeocodeSearchRequest *regeo;

@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *searchRequest;

@property (nonatomic, strong) TBNoticePromptBoxView *boxView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) TBShowAddressResultsView *resultsView;

@property (strong, nonatomic) UIImageView *centerImageView;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *locatingLabel;

@property (nonatomic, strong) CLLocation *myLocation;

@property (nonatomic, assign) BOOL isShowLocation;//是否已经定位过一次
@end

@implementation TBBusinessesLocateViewController

#pragma mark - Action Handle

- (void)cleanUpAction
{
    
    
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)confirmClick
{
    
    if (self.myLocation == nil||self.addressLabel.text.length == 0)
    {
        [self showLocationManager];
        return;
    }
    if ([self.activityView isAnimating] == YES)
    {
        hudShowInfo(@"请稍等！还在查询中。");
        return;
    }
    if (self.userLocation)
    {
        self.userLocation(self.addressLabel.text,self.myLocation.coordinate.latitude,self.myLocation.coordinate.longitude);
        [self goBack];
    }
}
/**
 定位
 */
- (void)showLocationManager;
{
    //判断用户定位服务是否开启
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        hudShowInfo(@"请到设置中心打开定位权限");
    }
    else
    {
        //进行单次带逆地理定位请求
        if (self.latitude>0&&self.longitude>0)
        {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
            CLLocation *cllocation = [[CLLocation alloc] initWithCoordinate:coordinate altitude:10 horizontalAccuracy:1 verticalAccuracy:1 timestamp:[NSDate date]];
            self.myLocation = cllocation;
            [self.mapView setCenterCoordinate:coordinate animated:YES];
            [self searchTheGeographical];
        }
        else
        {
            [self.mapView setShowsUserLocation:YES];
        }
    }
}
// 选中去的位置
- (void)showQueryResults:(AMapPOI *)poi
{
    self.isShowLocation = NO;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    self.myLocation = [[CLLocation alloc] initWithCoordinate:coordinate altitude:10 horizontalAccuracy:1 verticalAccuracy:1 timestamp:[NSDate date]];
    
    NSString *province = poi.province.length == 0?@"":poi.province;
    NSString *city = poi.city.length == 0?@"":poi.city;
    NSString *district = poi.district.length == 0?@"":poi.district;
    NSString *address = poi.address.length == 0?@"":poi.address;
    
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@",province,city,district,address,poi.name];;
    self.locatingLabel.text = [NSString stringWithFormat:@"N%.6f , E%.6f",poi.location.latitude,poi.location.longitude];
    
    TBWeakSelf
    [UIView animateWithDuration:0.4 animations:^{
        [weakSelf.resultsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    } completion:^(BOOL finished) {
        
        weakSelf.isShowLocation = YES;
    }];
}
- (void)goBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----MAMapViewDelegate--

/*!
 @brief 位置或者设备方向更新后调用此接口
 @param mapView 地图View
 @param userLocation 用户定位信息(包括位置与设备方向等数据)
 @param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation;
{
    [self.mapView setShowsUserLocation:NO];
    [self.mapView  setCenterCoordinate:userLocation.location.coordinate animated:YES];
    self.myLocation = userLocation.location;
    [self searchTheGeographical];
    [self.view endEditing:YES];
    
}
/*!
 @brief 定位失败后调用此接口
 @param mapView 地图View
 @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error;
{
    
    [self errPromptMessage:@"定位失败！"];
}
/**
 *  地图移动结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction;
{
    [self.view endEditing:YES];
    if (self.isShowLocation == YES)
    {
        self.myLocation = nil;
        CLLocation *cllocation = [[CLLocation alloc] initWithCoordinate:self.mapView.centerCoordinate altitude:10 horizontalAccuracy:1 verticalAccuracy:1 timestamp:[NSDate date]];
        self.myLocation = cllocation;
        [self searchTheGeographical];
    }
}
/**
 *  单击地图底图调用此接口
 *
 *  @param mapView    地图View
 *  @param coordinate 点击位置经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate;
{
    [self.view endEditing:YES];
}
#pragma mark ---AMapSearchDelegate--

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    [self.activityView stopAnimating];
    self.currentCity = response.regeocode.addressComponent.city;
    if (response.regeocode != nil)
    {
        AMapReGeocode *geocode = response.regeocode;
        self.addressLabel.text = geocode.formattedAddress;
        self.locatingLabel.text = [NSString stringWithFormat:@"N%.6f , E%.6f",self.myLocation.coordinate.latitude,self.myLocation.coordinate.longitude];
    }
    else /* from drag search, update address */
    {
        [self errPromptMessage:@"网络异常！"];
    }
    
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.activityView stopAnimating];
    if (response.pois.count == 0)
    {
        hudShowInfo(@"搜索无结果!");
        return;
    }
    else
    {
        [self.resultsView showAdderssPois:response.pois];
        
        [UIView animateWithDuration:0.4 animations:^{
            
            [self.resultsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@200);
            }];
            
        }];
    }
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [self.activityView stopAnimating];
    [self errPromptMessage:@"地理位置查询出错了！"];
}
#pragma mark --- 查询位置----
- (void)searchLocationKey:(NSString *)key
{
    if ([key isKindOfClass:[NSString class]])
    {
        [self.activityView startAnimating];
        self.searchRequest.city = self.currentCity;
        self.searchRequest.keywords = key;
        [self.search AMapPOIKeywordsSearch:self.searchRequest];
        
    }
}
#pragma mark - Initialization

- (void)searchTheGeographical
{
    if (self.myLocation)
    {
        [self.activityView startAnimating];
        self.regeo.location = [AMapGeoPoint locationWithLatitude:self.myLocation.coordinate.latitude longitude:self.myLocation.coordinate.longitude];
        self.regeo.requireExtension            = YES;
        [self.search AMapReGoecodeSearch:self.regeo];
    }
    else
    {
        [self errPromptMessage:@"定位异常"];
    }
    self.isShowLocation = YES;
    
}

- (void)errPromptMessage:(NSString *)ms
{
    hudShowError(ms);
    self.addressLabel.text = @"";
    self.locatingLabel.text = @"";
    self.myLocation = nil;
    
}
- (void)initMapView
{
    TBWeakSelf
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, _SCREEN_WIDTH, _SCREEN_HEIGHT-64-60)];
        [self.mapView setDelegate:self];
        [self.mapView setZoomLevel:18 animated:NO];
        [self.view insertSubview:self.mapView atIndex:999];
        
        [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-60);
        }];
    }
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.search.timeout = 8;
    self.currentCity = @"";
    self.regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    self.searchRequest = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    self.boxView = [[TBNoticePromptBoxView alloc] initShowPromptString:@"若定位有误，请拖动地图修正定位。"];
    self.boxView.frame = CGRectMake(30, 74, _SCREEN_WIDTH-60, 44);
    [self.mapView insertSubview:self.boxView atIndex:3000];
    [self.boxView showSearchKey:^(NSString *key) {
        
        [self searchLocationKey:key];
    }];
    
    UIImage *image = [UIImage imageNamed:@"map_myAdder"];
    self.centerImageView = [[UIImageView alloc] initWithImage:image];
    [self.mapView insertSubview:self.centerImageView atIndex:3001];
    self.centerImageView.hidden = NO;
    
    
    self.resultsView = [[TBShowAddressResultsView alloc] init];
    self.resultsView.backgroundColor = [UIColor clearColor];
    [self.mapView insertSubview:self.resultsView atIndex:3001];
    [self.resultsView setAdderssPoi:^(AMapPOI *poi) {
        
        [weakSelf showQueryResults:poi];
    }];
    
    [self.resultsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mapView);
        make.width.equalTo(weakSelf.mapView.mas_width).offset(-(60+54*2));
        make.top.equalTo(weakSelf.boxView.mas_bottom).offset(1);
        make.height.equalTo(@0);
    }];
    
    
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mapView.mas_centerX);
        make.centerY.equalTo(weakSelf.mapView.mas_centerY).offset(-image.size.height/2);
    }];
    
}
- (void)initActivityIndicatorView
{
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.color = [UIColor orangeColor];
    [self.mapView insertSubview:self.activityView atIndex:3100];
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.mapView);
        make.width.height.equalTo(@50);
    }];
    
}
- (void)initToolBar
{
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, _SCREEN_HEIGHT-60, _SCREEN_WIDTH, 60)];
    barView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:barView atIndex:100];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = [UIColor orangeColor];
    [confirmButton setTitle:@"确认我的位置" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [barView addSubview:confirmButton];
    
    UILabel *lefAdderss = [[UILabel alloc] init];
    lefAdderss.text = @"当前位置:";
    lefAdderss.font = [UIFont systemFontOfSize:14];
    lefAdderss.textAlignment = NSTextAlignmentCenter;
    lefAdderss.textColor = [UIColor blackColor];
    [barView addSubview:lefAdderss];
    
    UILabel *lefLocating = [[UILabel alloc] init];
    lefLocating.text = @"GPS坐标:";
    lefLocating.font = [UIFont systemFontOfSize:14];
    lefLocating.textColor = [UIColor blackColor];
    lefLocating.textAlignment = NSTextAlignmentCenter;
    [barView addSubview:lefLocating];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.text = @"";
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel.textColor = [UIColor blackColor];
    self.addressLabel.numberOfLines = 2;
    [barView addSubview:self.addressLabel];
    
    self.locatingLabel = [[UILabel alloc] init];
    self.locatingLabel.text = @"";
    self.locatingLabel.font = [UIFont systemFontOfSize:14];
    self.locatingLabel.textColor = [UIColor orangeColor];
    [barView addSubview:self.locatingLabel];
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.bottom.equalTo(barView);
        make.width.equalTo(@100);
    }];
    [lefAdderss mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(barView);
        make.width.equalTo(@74);
        make.height.equalTo(@40);
    }];
    [lefLocating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(barView);
        make.top.equalTo(lefAdderss.mas_bottom);
        make.width.equalTo(lefAdderss);
        make.height.equalTo(@20);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(barView);
        make.left.equalTo(lefAdderss.mas_right).offset(4);
        make.right.equalTo(confirmButton.mas_left).offset(-4);
        make.height.equalTo(lefAdderss.mas_height);
    }];
    
    [self.locatingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(barView);
        make.left.equalTo(lefLocating.mas_right).offset(4);
        make.right.equalTo(confirmButton.mas_left).offset(-4);
        make.height.equalTo(lefLocating.mas_height);
    }];
    
    
}

- (void)initNavigationBar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_back" highIcon:@"nav_back" target:self action:@selector(goBack)];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的位置";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initToolBar];
    
    [self initNavigationBar];
    
    [self initMapView];
    
    [self initActivityIndicatorView];
    
    [self showLocationManager];
    
    
}

- (void)dealloc
{
    [self cleanUpAction];
    
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = NO;
        annotationView.pinColor         = MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    
    return nil;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
