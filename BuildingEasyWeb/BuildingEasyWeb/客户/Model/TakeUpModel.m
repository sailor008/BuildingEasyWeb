//
//  TakeUpModel.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/29.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "TakeUpModel.h"

@implementation BuyerModel

@end

@implementation TakeUpModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _customerId = @"";
        _contacts = @"";
        _seller = @"";
        _agency = @"";
        _contactsMobile = @"";
        _agentMobile = @"";
        _agent = @"";
        _address = @"";
        _buildName = @"";
        _houseArea = @"";
        _area = @"";
        _price = @"";
        _total = @"";
        _earnest = @"";
        _type = @0;
        _recordTime = @"";
        _percent = @"";
        _money = @"";
        _signTime = @"";
        _buyers = [NSArray array];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"buyers" : @"BuyerModel"};
}

@end
