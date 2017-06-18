//
//  BuildBaobeiModel.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/18.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildBaobeiModel.h"

@implementation BuildBaobeiModel

- (BuildAdviser *)selectedAdviser
{
    if (_selectedAdviser) {
        return _selectedAdviser;
    }
    if (_adviserList.count) {
        return _adviserList[0];
    }
    return nil;
}

@end
