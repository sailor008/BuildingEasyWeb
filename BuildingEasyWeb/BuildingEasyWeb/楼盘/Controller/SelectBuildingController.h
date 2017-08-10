//
//  SelectBuildingController.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaseController.h"

@protocol SelectBuildingResultDelegate <NSObject>

- (void)selectBuildingResult:(NSArray *)buildIDs;

@end

@interface SelectBuildingController : BaseController

@property (nonatomic, copy) NSArray* selectedBuildArr;

@property (nonatomic, weak) id<SelectBuildingResultDelegate> delegate;

@end
