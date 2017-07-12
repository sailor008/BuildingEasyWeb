//
//  OpenSystemUrlManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/4.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "OpenSystemUrlManager.h"

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@implementation OpenSystemUrlManager

+ (void)sendMessage:(NSString *)phone
{
    NSString* urlStr = [NSString stringWithFormat:@"sms://%@", phone];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
//    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
//        if (success) {
//            NSLog(@"调起发短信");
//        }
//    }];
}

+ (void)callPhone:(NSString *)phone
{
    NSString* urlStr = [NSString stringWithFormat:@"tel://%@", phone];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
//    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
//        if (success) {
//            NSLog(@"调起打电话");
//        }
//    }];
}

+ (void)showMapGuideWithLat:(double)latitude lng:(double)longitude
{
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(latitude, longitude);
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
}

+ (void)jumpToContactSetting
{
    NSString* urlStr = nil;
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        urlStr = @"App-Prefs:root=CONTACTS";
    } else {
        urlStr = @"prefs:root=CONTACTS";
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

+ (void)jumpToLocationSetting
{
    NSString* urlStr = nil;
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        urlStr = @"App-Prefs:root=LOCATION_SERVICES";
    } else {
        urlStr = @"prefs:root=LOCATION_SERVICES";
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

+ (void)jumpToPhotoSetting
{
    NSString* urlStr = nil;
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        urlStr = @"App-Prefs:root=PHOTO";
    } else {
        urlStr = @"prefs:root=PHOTO";
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

@end
