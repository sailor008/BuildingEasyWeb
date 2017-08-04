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

static NSString* const kBaobeiNewSuccess = @"BaobeiNewSuccess";

static NSString* const kEditSuceess = @"EditSuceess";

static NSString* const kBaobeiModifySuccess = @"BaobeiModifySuccess";

static NSString* const kFirstLaunch = @"FirstLaunch";

static NSUInteger const kPerBaobeiBuildingMax = 6;


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

typedef NS_ENUM(NSInteger, StatisticState) {
    kStatisticStateAll         = -1,    // -1：全部
    kStatisticStateBaobeiBegin = 0,     // 0：发起报备
    kStatisticStateBaobeiVerify,        // 1：接受审核
    kStatisticStateBaobeiSuccess,       // 2：接受成功
    kStatisticStateWaitVisit,           // 3：待上门
    kStatisticStateVisiting,            // 4：系统已确认带看
    kStatisticStateVisitedVerify,       // 5：上传凭证带看后台审核
    kStatisticStateVisitedSuccess,      // 6：已上门
    kStatisticStateWaitSubscribe,       // 7：待认购
    kStatisticStateInSubscribe,         // 8：系统已确认认购
    kStatisticStateSubscribeVerify,     // 9：上传凭证后台审核
    kStatisticStateSubscribed,          // 10：已认购
    kStatisticStateWaitBuy,             // 11：待签约
    kStatisticStateBuying,              // 12：系统已确认签约
    kStatisticStateBuyVerify,           // 13：上传凭证后台审核
    kStatisticStateBought,              // 14：已签约
    kStatisticStateWaitPay,             // 15：待回款
    kStatisticStatePaying,              // 16：系统已确认回款
    kStatisticStatePayVerify,           // 17：上传凭证回款
    kStatisticStatePaid,                // 18：已回款
    kStatisticStateWaitCheckBill,       // 19：待结清
    kStatisticStateCheckingBill,        // 20：系统已确认结清
    kStatisticStateCheckBillVerify,     // 21：上传凭证确认结清
    kStatisticStateCheckedBill,         // 22：已结清
    kStatisticStateInvaild,             // 23：失效
};

static NSString* const StatisticStateString[] = {
    @"发起报备",
    @"接受审核",
    @"接受成功",
    @"待上门",
    @"系统已确认带看",
    @"上传凭证后台审核",
    @"已上门",
    @"待认购",
    @"系统已确认认购",
    @"上传凭证后台审核",
    @"已认购",
    @"待签约",
    @"系统已确认签约",
    @"上传凭证后台审核",
    @"已签约",
    @"待回款",
    @"系统已确认回款",
    @"上传凭证回款",
    @"已回款",
    @"待结清",
    @"系统已确认结清",
    @"上传凭证结清",
    @"已结清",
    @"失效",
};


typedef NS_ENUM(NSInteger, IntentionLevel) {
    kIntentionLevelWeak,          // 0：弱（意向程度）
    kIntentionLevelMiddle,        // 1：中（意向程度）
    kIntentionLevelStrong,        // 2：强（意向程度）
};

// 用户的认证状态
typedef NS_ENUM(NSInteger, UserAuthState) {
    kAuthStateNO,    // 0：未认证
    kAuthStateWait,  // 1：待认证
    kAuthStateYES,   // 2：已认证
    kAuthStateFAIL,  // 3：认证失败
};

typedef void(^Callback)();

typedef void(^FailureBlock)(NSError* error, NSString* msg);

@interface Global : NSObject

// 切换到客户列表首页
+ (void)tranToCustomerListVCFromVC:(UIViewController *)currentVC;

@end
