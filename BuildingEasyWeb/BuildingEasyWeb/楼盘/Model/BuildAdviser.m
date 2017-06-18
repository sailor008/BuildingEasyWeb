//
//  BuildAdviser.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/18.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildAdviser.h"

@implementation BuildAdviser

@end

@implementation BuildAdviserItem

- (NSString *)selectedAdviserID
{
    if (_selectedAdviserID.length) {
        return _selectedAdviserID;
    }
    if (self.adviserList.count) {
        BuildAdviser* adviser = self.adviserList[0];
        return adviser.adviserId;
    }
    return @"0";
}

@end
