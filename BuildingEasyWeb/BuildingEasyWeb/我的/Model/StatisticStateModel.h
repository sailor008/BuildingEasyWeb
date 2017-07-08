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

