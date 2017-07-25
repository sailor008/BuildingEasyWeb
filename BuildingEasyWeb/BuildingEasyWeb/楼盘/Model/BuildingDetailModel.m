//
//  BuildingDetailModel.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/16.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildingDetailModel.h"

@implementation DetailAdviser

@end

@implementation FormulaModel

@end

@implementation BuildingInfoModel

@end

@implementation BuildingDetailModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"formulaList" : @"FormulaModel",
             @"advisers" : @"DetailAdviser"};
}

@end
