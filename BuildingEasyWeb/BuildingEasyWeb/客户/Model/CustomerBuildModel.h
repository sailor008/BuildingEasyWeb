//
//  CustomerBuildModel.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/19.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BuildAdviser.h"

@interface CustomerBuildModel : NSObject

@property (nonatomic, copy) NSString* customerId;
@property (nonatomic, copy) NSString* customerName;
@property (nonatomic, copy) NSString* customerMobile;
@property (nonatomic, assign) NSInteger intention;
@property (nonatomic, assign) NSInteger currentState;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, copy) NSString* buildId;
@property (nonatomic, copy) NSString* buildName;
@property (nonatomic, copy) NSString* desc;

@property (nonatomic, strong) BuildAdviser* adviser;

@end
