//
//  LocationManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/3.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "LocationManager.h"

#import <CoreLocation/CoreLocation.h>

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) LocationCity city;

@end

@implementation LocationManager

+ (instancetype)shareLocation
{
    static LocationManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LocationManager alloc] init];
        manager.locationManager = [[CLLocationManager alloc] init];
//        [manager.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        manager.locationManager.delegate = manager;
    });
    return manager;
}

+ (void)startGetLocation:(LocationCity)locationCity
{
    if ([CLLocationManager locationServicesEnabled]) {
        // 开始定位
        //        [_locationManager requestLocation];
        [LocationManager shareLocation].city = locationCity;
        [[[LocationManager shareLocation] locationManager] requestWhenInUseAuthorization];
        [[[LocationManager shareLocation] locationManager] startUpdatingLocation];
    }
}

/** 获取到新的位置信息时调用*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       NSString* city = nil;
                       for (CLPlacemark *place in placemarks) {
//                          NSLog(@"name,%@",place.name);                       // 位置名
//                          NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
//                          NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
//                          NSLog(@"locality,%@",place.locality);               // 市
//                          NSLog(@"subLocality,%@",place.subLocality);         // 区
//                          NSLog(@"country,%@",place.country);                 // 国家
                           
                           city = place.locality;
                       }
                       
                       self.city(city, coordinate.latitude, coordinate.longitude);
                       
                   }];
}
/** 不能获取位置信息时调用*/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.city(@"", 0.0, 0.0);
    NSLog(@"获取定位失败");
}

@end
