//
//  Global.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/5.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

static NSString* const kShareSuccess = @"ShareToWXSuccess";

typedef NS_ENUM(NSInteger, BEWUserRole) {
    kPersonRole = 0,
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

// 编辑页面的三种状态
typedef NS_ENUM(NSInteger, BEWEditType) {
    kEditTypeNew,   // 新建
    kEditTypeAgain, // 编辑
    kEditTypeDetail // 查看
};

typedef void(^Callback)();

typedef void(^FailureBlock)(NSError* error, NSString* msg);

@interface Global : NSObject

// 切换到客户列表首页
+ (void)tranToCustomerListVCFromVC:(UIViewController *)currentVC;

@end
