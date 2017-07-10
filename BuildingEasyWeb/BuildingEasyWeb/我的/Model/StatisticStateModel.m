//
//  StatisticStateModel.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/7.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "StatisticStateModel.h"

@implementation StatisticStateModel

- (NSString*)getStateDetailStr
{
    NSString* stateDetail = [NSString stringWithFormat:@"%@(%@)", self.stateDesc, self.num];
    return stateDetail;
}

@end


@implementation BaobeiInfoModel

@end

