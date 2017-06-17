//
//  CustomerDetailModel.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/17.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateList : NSObject

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger time;

@end

@interface Adviser : NSObject

@property (nonatomic, copy) NSString* adviserId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* mobile;

@end

@interface CustomerDetailModel : NSObject

@property (nonatomic, copy) NSString* buildId;
@property (nonatomic, copy) NSString* buildName;
@property (nonatomic, copy) NSString* customerId;
@property (nonatomic, copy) NSString* customerMobile;
@property (nonatomic, copy) NSString* customerName;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger currentState;
@property (nonatomic, assign) NSInteger intention;

@property (nonatomic, copy) NSArray* stateList;
@property (nonatomic, copy) NSArray* adviser;

@end
