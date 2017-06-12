//
//  CityModel.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/11.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "CityModel.h"

@implementation AreaModel

@end

@implementation CityModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"areaList" : @"AreaModel"};
}

@end

@implementation ProvinceModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"cityList" : @"CityModel"};
}

@end

@implementation AllAreaList

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"provinceCityList" : @"ProvinceModel"};
}

@end
