//
//  GetImageTokenManager.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/28.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Global.h"

typedef void(^ImageToken)(NSString* upToken, NSString* keyStr);

@interface GetImageTokenManager : NSObject

+ (void)getImageTokenWithType:(NSString *)type tokenBlock:(ImageToken)tokenBlock failure:(FailureBlock)failureBlock;

@end
