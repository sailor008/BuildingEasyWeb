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

typedef NS_ENUM(NSInteger, BEWProgressState) {
    kBaobeiState,// 报备
    kVisitState,// 带看
    kTakeupState,// 认购
    kDealState,// 签约
    kPayState,// 回款
    kSettleState,// 结清
    kInvalidState// 失效
};

typedef void(^Callback)();

@interface Global : NSObject

@end
