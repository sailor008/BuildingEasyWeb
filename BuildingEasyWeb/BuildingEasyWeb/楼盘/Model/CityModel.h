//
//  CityModel.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/11.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaModel : NSObject

@property (nonatomic, copy) NSString* areaCode;
@property (nonatomic, copy) NSString* areaName;

@end

@interface CityModel : NSObject

@property (nonatomic, copy) NSString* cityCode;
@property (nonatomic, copy) NSString* viewCityName;
@property (nonatomic, copy) NSArray* areaList;

@end

@interface ProvinceModel : NSObject

@property (nonatomic, copy) NSString* provinceCode;
@property (nonatomic, copy) NSString* provinceName;
@property (nonatomic, copy) NSArray* cityList;

@end

@interface AllAreaList : NSObject

@property (nonatomic, copy) NSArray* provinceCityList;

@end
