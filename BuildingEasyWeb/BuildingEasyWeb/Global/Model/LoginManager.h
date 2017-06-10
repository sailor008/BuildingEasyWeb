//
//  LoginManager.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

+ (void)login:(NSString *)phone password:(NSString *)password;
+ (void)registerNewCount:(NSString *)phone password:(NSString *)password code:(NSString *)code role:(NSNumber *)role;
+ (void)requestVerificationCode:(NSString *)phone;

@end
