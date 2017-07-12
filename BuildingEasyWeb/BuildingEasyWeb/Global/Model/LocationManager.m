//
//  LocationManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/3.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "LocationManager.h"

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

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
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||  [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
            // 开始定位
            //        [_locationManager requestLocation];
            [LocationManager shareLocation].city = locationCity;
            [[[LocationManager shareLocation] locationManager] requestWhenInUseAuthorization];
            [[[LocationManager shareLocation] locationManager] startUpdatingLocation];
        } else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"定位服务未开启" message:@"请前往「系统设置 > 隐私」开启定位服务" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* gotoAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString* urlStr = nil;
                if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
                    urlStr = @"App-Prefs:root=LOCATION_SERVICES";
                } else {
                    urlStr = @"prefs:root=LOCATION_SERVICES";
                }
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }
            }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:gotoAction];
            [alert addAction:cancelAction];
            
            UIViewController* rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootVC presentViewController:alert animated:YES completion:nil];
        }
        
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
    [manager stopUpdatingLocation];
    self.city(@"", 0.0, 0.0);
    NSLog(@"获取定位失败");
}

@end
