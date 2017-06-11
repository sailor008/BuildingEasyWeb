//
//  Global.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/5.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BEWUserRole) {
    kPersonRole = 1,
    kAgencyRole
};

typedef void(^Callback)();

@interface Global : NSObject

@end
