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

// 以下字段针对城市列表增加 wx/getCityListByInitial
@property (nonatomic, copy) NSString* cityName;
@property (nonatomic, assign) BOOL hotCity;

@end

@interface ProvinceModel : NSObject

@property (nonatomic, copy) NSString* provinceCode;
@property (nonatomic, copy) NSString* provinceName;
@property (nonatomic, copy) NSArray* cityList;

@end

@interface AllAreaList : NSObject

@property (nonatomic, copy) NSArray* provinceCityList;

@end

@interface CityListByInitial : NSObject

@property (nonatomic, copy) NSString* initial;// 首字母
@property (nonatomic, copy) NSArray* city;

@end
