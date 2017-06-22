//
//  CityListController.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaseController.h"

@protocol CityListControllerDelegate <NSObject>

- (void)selectedCity:(NSString *)city cityCode:(NSString *)cityCode;

@end

@interface CityListController : BaseController

@property (nonatomic, copy) NSString* currentCity;

@property (nonatomic, weak) id<CityListControllerDelegate> delegate;

@end
