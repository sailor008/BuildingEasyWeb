//
//  BuildBaobeiModel.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/18.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BuildAdviser.h"
#import "BuildingListModel.h"

@interface BuildBaobeiModel : NSObject

@property (nonatomic, strong) BuildingListModel* buildModel;
@property (nonatomic, strong) NSMutableArray* adviserList;

@property (nonatomic, strong) BuildAdviser* selectedAdviser;

@end
