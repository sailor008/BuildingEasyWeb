//
//  BuildingDetailModel.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/16.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormulaModel : NSObject

@property (nonatomic, copy) NSString* formula;
@property (nonatomic, copy) NSString* apartment;
@property (nonatomic, copy) NSString* formulaDesc;
@property (nonatomic, copy) NSString* buildDesc;
@property (nonatomic, copy) NSString* formulaId;

@end

@interface BuildingInfoModel : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* average;
@property (nonatomic, copy) NSString* rules;
@property (nonatomic, copy) NSString* houseType;
@property (nonatomic, copy) NSString* sellingPoint;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, assign) BOOL isBamboo;

// 基本信息
@property (nonatomic, copy) NSString* area;
@property (nonatomic, copy) NSString* developers;
@property (nonatomic, copy) NSString* openTime;
@property (nonatomic, copy) NSString* handTime;
@property (nonatomic, copy) NSString* decorate;
@property (nonatomic, copy) NSString* acreage;
@property (nonatomic, copy) NSString* households;
@property (nonatomic, copy) NSString* carport;
@property (nonatomic, copy) NSString* carportPercent;
@property (nonatomic, copy) NSString* greenRate;
@property (nonatomic, copy) NSString* term;
@property (nonatomic, copy) NSString* acreageRate;
@property (nonatomic, copy) NSString* bank;
@property (nonatomic, copy) NSString* property;
@property (nonatomic, copy) NSString* propertyMoney;
@property (nonatomic, copy) NSString* longitude; //经度
@property (nonatomic, copy) NSString* latitude;  //纬度


//
@property (nonatomic, copy) NSString* position;
@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* staff;

@end

@interface BuildingDetailModel : NSObject

@property (nonatomic, strong) BuildingInfoModel* buildInfo;
@property (nonatomic, copy) NSArray* formulaList;

@end
