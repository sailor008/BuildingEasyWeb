//
//  LocationManager.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/3.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LocationCity)(NSString* city, double lat, double lng);

@interface LocationManager : NSObject

+ (instancetype)shareLocation;

+ (void)startGetLocation:(LocationCity)locationCity;

@end
