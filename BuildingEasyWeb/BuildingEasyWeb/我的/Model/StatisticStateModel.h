//
//  StatisticStateModel.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/7.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticStateModel : NSObject

@property (nonatomic, copy) NSNumber* state;
@property (nonatomic, copy) NSNumber* num;
@property (nonatomic, copy) NSString* stateDesc;

- (NSString*)getStateDetailStr;

@end


@interface BaobeiInfoModel : NSObject

@property (nonatomic, copy) NSString* customerId;
@property (nonatomic, copy) NSString* customerName;
@property (nonatomic, copy) NSString* customerMobile;
@property (nonatomic, assign) NSInteger intention;
@property (nonatomic, assign) NSUInteger createTime;
@property (nonatomic, copy) NSString* buildName;
@property (nonatomic, assign) NSInteger invalidDay;
@property (nonatomic, assign) NSInteger state;

@end

