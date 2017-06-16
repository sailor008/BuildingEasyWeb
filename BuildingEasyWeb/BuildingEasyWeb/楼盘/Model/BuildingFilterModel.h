//
//  BuildingFilterModel.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/16.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildingTypeModel : NSObject

@property (nonatomic, copy) NSString* classifyId;
@property (nonatomic, copy) NSString* classifyName;

@end

@interface BuildingPriceModel : NSObject

@property (nonatomic, copy) NSString* averageId;
@property (nonatomic, copy) NSString* interval;

@end

@interface BuildingDistanceModel : NSObject

@property (nonatomic, copy) NSString* distanceId;
@property (nonatomic, copy) NSString* interval;

@end
