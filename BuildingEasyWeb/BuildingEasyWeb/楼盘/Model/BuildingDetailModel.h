//
//  BuildingDetailModel.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/16.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildingInfoModel : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* average;
@property (nonatomic, copy) NSString* rules;
@property (nonatomic, copy) NSString* houseType;
@property (nonatomic, copy) NSString* sellingPoint;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, assign) BOOL isBamboo;
//@property (nonatomic, copy) NSString* name;
//@property (nonatomic, copy) NSString* name;
//@property (nonatomic, copy) NSString* name;
//@property (nonatomic, copy) NSString* name;
//@property (nonatomic, copy) NSString* name;
//@property (nonatomic, copy) NSString* name;
//@property (nonatomic, copy) NSString* name;


@end

@interface BuildingDetailModel : NSObject

@property (nonatomic, strong) BuildingInfoModel* buildInfo;

@end
