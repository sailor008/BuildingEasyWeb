//
//  LoginManager.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Global.h"

@interface LoginManager : NSObject

+ (void)login:(NSString *)phone password:(NSString *)password callback:(Callback)callback;
+ (void)registerWithInfo:(NSDictionary *)info;

+ (void)getUserInfo;

+ (void)findPassWord:(NSString *)mobile pwd:(NSString *)pwd code:(NSString *)code;

@end
